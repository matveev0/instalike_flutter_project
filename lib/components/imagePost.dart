import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instalike_flutter_project/components/database.dart';
import 'package:instalike_flutter_project/components/post.dart';
import 'package:instalike_flutter_project/components/user.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../size_config.dart';

class ImagePost extends StatefulWidget {
  const ImagePost(
      {this.mediaUrl, this.username, this.likes, this.postId, this.ownerId});

  factory ImagePost.fromDocument(DocumentSnapshot document) {
    return ImagePost(
      mediaUrl: document['mediaUrl'],
      likes: document['likes'],
      postId: document.id,
      ownerId: document['userId'],
    );
  }

  factory ImagePost.fromPost(Post post, LocalUserModel user) {
    return ImagePost(
      username: user.name,
      mediaUrl: post.mediaUrl,
      likes: post.likes,
      ownerId: post.userId,
      postId: post.id,
    );
  }

  int getLikeCount(var likes) {
    if (likes == null) {
      return 0;
    }
    var vals = likes.values;
    int count = 0;
    for (var val in vals) {
      if (val == true) {
        count++;
      }
    }
    return count;
  }

  final String mediaUrl;
  final String username;
  final likes;
  final String postId;
  final String ownerId;

  _ImagePost createState() => _ImagePost(
        mediaUrl: this.mediaUrl,
        username: this.username,
        likes: this.likes,
        likeCount: getLikeCount(this.likes),
        ownerId: this.ownerId,
        postId: this.postId,
      );
}

class _ImagePost extends State<ImagePost> {
  final String mediaUrl;
  final String username;
  Map likes;
  int likeCount;
  final String postId;
  bool liked;
  final String ownerId;

  var reference = FirebaseFirestore.instance.collection('posts');
  LocalUserModel user;

  _ImagePost(
      {this.mediaUrl,
      this.username,
      this.likes,
      this.postId,
      this.likeCount,
      this.ownerId});

  GestureDetector buildLikeIcon() {
    return GestureDetector(
      child: LikeButton(
        size: 25.0,
        circleColor: CircleColor(start: Colors.red, end: Color(0xff0099cc)),
        bubblesColor: BubblesColor(
          dotPrimaryColor: Colors.red,
          dotSecondaryColor: Colors.red,
        ),
        likeBuilder: (bool isLiked) {
          return Icon(
            FontAwesomeIcons.solidHeart,
            color: liked ? Colors.red : Colors.grey,
          );
        },
        likeCount: likeCount,
        countBuilder: (int count, bool isLiked, String text) {
          var color = liked ? Colors.red : Colors.grey;
          Widget result;
          result = Text(
            text,
            style: TextStyle(color: color),
          );
          return result;
        },
        onTap: onLikeButtonTapped,
      ),
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    return _likePost(postId);
  }

  GestureDetector buildLikeableImage() {
    return GestureDetector(
      onDoubleTap: () => _likePost(postId),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            mediaUrl,
            fit: BoxFit.fitWidth,
            height: getProportionateScreenHeight(300),
            width: getProportionateScreenWidth(300),
          ),
        ],
      ),
    );
  }

  buildPostHeader({String ownerId}) {
    if (ownerId == null) {
      return Text("owner error");
    }

    return FutureBuilder(
        future: DataBaseService().getUser(ownerId),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return ListTile(
              leading: buildAvatar(user: snapshot.data),
              title: GestureDetector(
                child: Text(snapshot.data.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            );
          }
          return Container();
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

  @override
  Widget build(BuildContext context) {
    user = Provider.of<LocalUserModel>(context);
    if (user != null) {
      liked = (likes[user.id] == true);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(ownerId: ownerId),
        buildLikeableImage(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(left: 30.0, top: 10.0)),
            buildLikeIcon(),
            Padding(padding: const EdgeInsets.only(right: 5.0)),
          ],
        ),
        Divider(),
      ],
    );
  }

  bool _likePost(String postId2) {
    var userId = user.id;
    bool _liked = likes[userId] == true;

    if (_liked) {
      reference.doc(postId).update({'likes.$userId': false});

      setState(() {
        likeCount = likeCount - 1;
        liked = false;
        likes[userId] = false;
      });
    }

    if (!_liked) {
      setState(() {
        likeCount++;
        liked = true;
        likes[userId] = true;
      });
      reference.doc(postId).update({'likes.$userId': true});
    }

    return liked;
  }
}
