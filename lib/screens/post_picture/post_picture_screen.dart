import 'package:flutter/material.dart';
import 'package:instalike_flutter_project/components/custom_bottom_nav_bar.dart';

import '../../enums.dart';
import 'components/body.dart';

class PostPictureScreen extends StatelessWidget {
  static String routeName = "/post_picture";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.add_post),
    );
  }
}
