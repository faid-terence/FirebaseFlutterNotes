// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_auth/components/custom_button.dart';
import 'package:flutter_simple_auth/components/custom_text_field.dart';
import 'package:flutter_simple_auth/utils/display_message_user_util.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key, this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  void loginUser() async {
    // show a loader
    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      if (passwordController.text.isEmpty || emailController.text.isEmpty) {
        // pop loader
        if (context.mounted) {
          Navigator.pop(context);
        }

        // show error message
        displayMessageToUser(context, "Please fill all fields", Colors.red);
        return;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // pop loader
      if (context.mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      // pop loader
      if (context.mounted) {
        Navigator.pop(context);
      }

      // show error message
      displayMessageToUser(
        context,
        e.message ?? "An error occurred",
        Colors.red,
      );
    } catch (e) {
      // pop loader
      if (context.mounted) {
        Navigator.pop(context);
      }

      // show error message
      displayMessageToUser(context, e.toString(), Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            spacing: 25,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person, size: 80),
              // app name
              Text("C O D E X", style: TextStyle(fontSize: 20)),

              // email field
              Customtextfield(
                hintText: "Email",
                obscureText: false,
                textEditingController: emailController,
              ),

              // Password
              Customtextfield(
                hintText: "Password",
                obscureText: true,
                textEditingController: passwordController,
              ),

              CustomButton(text: "Login", onPressed: loginUser),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  Text("Don't have an account?"),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
