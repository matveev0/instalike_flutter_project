import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instalike_flutter_project/routes.dart';
import 'package:instalike_flutter_project/screens/start_page/start_page.dart';
import 'package:instalike_flutter_project/theme.dart';
import 'package:provider/provider.dart';

import 'components/auth.dart';
import 'components/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<LocalUserModel>.value(
      value: AuthService().currentUser,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyInst',
        theme: theme(),
        initialRoute: StartPage.routeName,
        routes: routes,
      ),
    );
  }
}
