import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instalike_flutter_project/components/user.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../constants.dart';

class ProfilePic extends StatelessWidget {
  final ImagePicker imagePicker = ImagePicker();
  LocalUserModel localUser;

  @override
  Widget build(BuildContext context) {
    localUser = Provider.of<LocalUserModel>(context);

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(localUser.id.trim())
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());
          }

          LocalUserModel user = LocalUserModel.fromDocument(snapshot.data);

          return SizedBox(
            height: 115,
            width: 115,
            child: Stack(
              fit: StackFit.expand,
              overflow: Overflow.visible,
              children: [
                buildAvatar(user: user),
                Positioned(
                  right: -16,
                  bottom: 0,
                  child: SizedBox(
                    height: 46,
                    width: 46,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Colors.white),
                      ),
                      color: Color(0xFFF5F6F9),
                      onPressed: () {
                        selectImage(context);
                      },
                      child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  CircleAvatar buildAvatar({LocalUserModel user}) {
    if (user.photoUrl == null) {
      return CircleAvatar(
        backgroundImage: AssetImage("assets/images/empty_ava.png"),
      );
    } else {
      return CircleAvatar(
        backgroundImage: NetworkImage(user.photoUrl),
      );
    }
  }

  selectImage(BuildContext parentContext) async {
    File file;

    return showDialog<Null>(
      context: parentContext,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Change an Avatar',
              style: TextStyle(color: kPrimaryColor)),
          children: <Widget>[
            Divider(),
            SimpleDialogOption(
                child: Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  PickedFile imageFile = await imagePicker.getImage(
                      source: ImageSource.camera,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80);
                  file = File(imageFile.path);
                  String imageUrl = await uploadImage(file);
                  applyNewPhoto(imageUrl);
                }),
            Divider(),
            SimpleDialogOption(
                child: Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  PickedFile imageFile = await imagePicker.getImage(
                      source: ImageSource.gallery,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80);
                  file = File(imageFile.path);
                  String imageUrl = await uploadImage(file);
                  applyNewPhoto(imageUrl);
                }),
            Divider(),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Future<String> uploadImage(var imageFile) async {
    var id = Uuid().v1();
    Reference ref = FirebaseStorage.instance.ref().child("post_$id.jpg");
    UploadTask uploadTask = ref.putFile(imageFile);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  applyNewPhoto(String photoUrl) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(localUser.id)
        .update({"photoUrl": photoUrl});
  }
}
