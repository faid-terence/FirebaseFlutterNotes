import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_auth/auth/auth_helper.dart';
import 'package:flutter_simple_auth/screens/home_screen.dart';

class FirebaseNavigatorHelper extends StatelessWidget {
  const FirebaseNavigatorHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return HomeScreen();
          } else if (snapshot.hasError) {
            return const Center(child: Text("An error occurred"));
          } else {
            return AuthHelper();
          }
        },
      ),
    );
  }
}
