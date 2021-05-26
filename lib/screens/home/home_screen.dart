import 'package:flutter/material.dart';
import 'package:instalike_flutter_project/components/custom_bottom_nav_bar.dart';
import 'package:instalike_flutter_project/components/database.dart';
import 'package:instalike_flutter_project/components/imagePost.dart';
import 'package:instalike_flutter_project/components/post.dart';
import 'package:instalike_flutter_project/components/user.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../enums.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  HomeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  LocalUserModel user;
  List<Post> posts;
  List<ImagePost> feedData;

  buildFeed() {
    if (feedData != null) {
      return ListView(
        children: feedData.reversed.toList(),
      );
    } else {
      return Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<LocalUserModel>(context);
    _getFeed();
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MyInstagram",
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: buildFeed(),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }

  Future<Null> _refresh() async {
    await _getFeed();

    setState(() {});

    return;
  }

  _getFeed() async {
    List<ImagePost> listOfPosts;
    posts = await DataBaseService().getPosts();
    if (user == null) {
      return;
    }
    LocalUserModel userFromDb = await DataBaseService().getUser(user.id);
    listOfPosts = _generateFeed(posts, userFromDb);
    setState(() {
      feedData = listOfPosts;
    });
  }

  List<ImagePost> _generateFeed(List<Post> posts, userFromDb) {
    List<ImagePost> listOfPosts = [];

    for (var post in posts) {
      listOfPosts.add(ImagePost.fromPost(post, userFromDb));
    }
    return listOfPosts;
  }

  @override
  bool get wantKeepAlive => true;
}
