import 'package:flutter/widgets.dart';
import 'package:instalike_flutter_project/screens/edit_profile/edit_profile_screen.dart';
import 'package:instalike_flutter_project/screens/home/home_screen.dart';
import 'package:instalike_flutter_project/screens/post_picture/post_picture_screen.dart';
import 'package:instalike_flutter_project/screens/profile/profile_screen.dart';
import 'package:instalike_flutter_project/screens/sign_in/sign_in_screen.dart';
import 'package:instalike_flutter_project/screens/splash/splash_screen.dart';
import 'package:instalike_flutter_project/screens/start_page/start_page.dart';

import 'screens/sign_up/sign_up_screen.dart';

// All our routes
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  EditProfileScreen.routeName: (context) => EditProfileScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  PostPictureScreen.routeName: (context) => PostPictureScreen(),
  StartPage.routeName: (context) => StartPage(),
};
