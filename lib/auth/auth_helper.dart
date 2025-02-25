import 'package:flutter/material.dart';
import 'package:flutter_simple_auth/screens/login_screen.dart';
import 'package:flutter_simple_auth/screens/register_screen.dart';

class AuthHelper extends StatefulWidget {
  const AuthHelper({super.key});

  @override
  State<AuthHelper> createState() => _AuthHelperState();
}

class _AuthHelperState extends State<AuthHelper> {
  // initially show login page

  bool showLogin = true;

  // function to toggle between login and register page

  void toggleView() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLogin
        ? LoginScreen(onTap: toggleView)
        : RegisterScreen(onTap: toggleView);
  }
}
