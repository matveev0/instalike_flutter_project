import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instalike_flutter_project/components/database.dart';
import 'package:instalike_flutter_project/components/default_button.dart';
import 'package:instalike_flutter_project/components/post.dart';
import 'package:instalike_flutter_project/components/user.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  File file;
  ImagePicker imagePicker = ImagePicker();
  bool uploading = false;
  LocalUserModel user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<LocalUserModel>(context);

    return file == null
        ? Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 330),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: DefaultButton(
                text: "Post new picture",
                press: () => {_selectImage(context)},
              ),
            ))
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.white70,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: clearImage),
              title:  Text(
                'Post to',
                style:  TextStyle(
                  color: kPrimaryColor
                ),
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: postImage,
                    child: Text(
                      "Post",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ))
              ],
            ),
            body: ListView(
              children: <Widget>[
                PostForm(
                  imageFile: file,
                  loading: uploading,
                ),
                Divider() //scroll view where we will show location to users
              ],
            ));
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog<Null>(
      context: parentContext,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post',
              style: TextStyle(
                  color: kPrimaryColor)),
          children: <Widget>[
            Divider(),
            SimpleDialogOption(
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  PickedFile imageFile = await imagePicker.getImage(
                      source: ImageSource.camera,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80);
                  setState(() {
                    file = File(imageFile.path);
                  });
                }),
            Divider(),
            SimpleDialogOption(
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  PickedFile imageFile = await imagePicker.getImage(
                      source: ImageSource.gallery,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80);
                  setState(() {
                    file = File(imageFile.path);
                  });
                }),
            Divider(),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void clearImage() {
    setState(() {
      file = null;
    });
  }

  void postImage() {
    setState(() {
      uploading = true;
    });
    uploadImage(file).then((String data) {
      postToFireStore(data);
    }).then((_) {
      setState(() {
        file = null;
        uploading = false;
      });
    });
  }

  Future<String> uploadImage(var imageFile) async {
    var id = Uuid().v1();
    Reference ref = FirebaseStorage.instance.ref().child("post_$id.jpg");
    UploadTask uploadTask = ref.putFile(imageFile);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  void postToFireStore(String mediaUrl) async {
    Map<String, bool> likes = Map();
    likes.putIfAbsent(user.id, () => false);
    DataBaseService().createPost(Post.fromParameters(
        Uuid().v1(), mediaUrl, user.id, likes, DateTime.now()));
  }
}

class PostForm extends StatelessWidget {
  final imageFile;
  final bool loading;

  PostForm({this.imageFile, this.loading});

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        loading
            ? LinearProgressIndicator()
            : Padding(padding: EdgeInsets.only(top: 0.0)),
        Divider(),
        Container(
            height: 360,
            width: 360,
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  alignment: FractionalOffset.topCenter,
                  image: FileImage(imageFile),
                ))
        ),
        Divider()
      ],
    );
  }
}

