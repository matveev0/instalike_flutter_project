import 'package:flutter/material.dart';
import 'package:instalike_flutter_project/components/custom_bottom_nav_bar.dart';

import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';
import 'components/body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile",
          style: TextStyle(
              fontSize: getProportionateScreenWidth(16),
              color: kPrimaryColor)
    ),
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
