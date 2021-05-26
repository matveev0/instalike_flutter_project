import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instalike_flutter_project/components/auth.dart';
import 'package:instalike_flutter_project/components/database.dart';
import 'package:instalike_flutter_project/components/user.dart';
import 'package:instalike_flutter_project/screens/edit_profile/edit_profile_screen.dart';
import 'package:instalike_flutter_project/screens/profile/components/user_post.dart';
import 'package:instalike_flutter_project/screens/sign_in/sign_in_screen.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../components/imagePost.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  LocalUserModel localUser;

  @override
  Widget build(BuildContext context) {
    localUser = Provider.of<LocalUserModel>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          getUserNameText(context),
          SizedBox(height: 20),
          ProfileMenu(
            text: "Edit Account",
            icon: "assets/icons/User Icon.svg",
            press: () =>
                {Navigator.pushNamed(context, EditProfileScreen.routeName)},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () {
              _logout(context);
              Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName,
                  (Route<dynamic> route) => false);
            },
          ),
          buildUserPosts()
        ],
      ),
    );
  }

  FutureBuilder getUserNameText(BuildContext context) {
    return FutureBuilder(
      future: DataBaseService().getUserName(Provider.of<LocalUserModel>(context).id),
      builder: (_, AsyncSnapshot snapshot) {
        if (snapshot.data != null) {
          return Text(snapshot.data,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(36),
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ));
        } else {
          return Container();
        }
      },
    );
  }

  void _logout(BuildContext context) async {
    await AuthService().logout();
  }

  Container buildUserPosts() {
    Future<List<ImagePost>> getPosts() async {
      List<ImagePost> posts = [];
      var snap = await FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: localUser.id)
          .get();
      for (var doc in snap.docs) {
        posts.add(ImagePost.fromDocument(doc));
      }

      if (posts.isEmpty) {
        return null;
      }
      return posts.reversed.toList();
    }

    return Container(
        child: FutureBuilder<List<ImagePost>>(
      future: getPosts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            padding: const EdgeInsets.all(0.5),
            mainAxisSpacing: 1.5,
            crossAxisSpacing: 1.5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: snapshot.data.map((ImagePost imagePost) {
              return GridTile(child: ImageTile(imagePost));
            }).toList());
      },
    ));
  }
}


