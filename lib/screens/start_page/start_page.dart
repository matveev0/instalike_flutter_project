import 'package:flutter/material.dart';
import 'package:instalike_flutter_project/components/user.dart';
import 'package:instalike_flutter_project/screens/home/home_screen.dart';
import 'package:instalike_flutter_project/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';

import '../../size_config.dart';

class StartPage extends StatelessWidget {
  static String routeName = "/start_page";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final LocalUserModel user = Provider.of<LocalUserModel>(context);
    final bool _isLogged = user != null;
    if (_isLogged) {
      return HomeScreen();
    } else {
      return SplashScreen();
    }
  }
}
