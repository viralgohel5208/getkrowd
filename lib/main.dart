import 'package:flutter/material.dart';
import 'package:getkrowd/screens/Account/login_screen.dart';
import 'package:getkrowd/screens/BottomBar/BottomVC.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var prefs = await SharedPreferences.getInstance();
  final bool isLogin = prefs.getBool('isLogin') ?? false;

  runApp(
    MaterialApp(
      home: isLogin == false ? const LoginScreen() : const BottomVC(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
