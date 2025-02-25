// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_auth/components/custom_button.dart';
import 'package:flutter_simple_auth/components/custom_text_field.dart';
import 'package:flutter_simple_auth/utils/display_message_user_util.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  const RegisterScreen({super.key, this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  // function to register a user
  void registerUser() async {
    // show a loader
    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    // check password match
    if (passwordController.text != confirmPasswordController.text) {
      // show error message
      displayMessageToUser(context, "Passwords do not match", Colors.red);
    } else {
      // create user
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // pop loader
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // pop loader
        Navigator.pop(context);

        // show error message
        displayMessageToUser(
          context,
          e.message ?? "An error occurred",
          Colors.red,
        );
      } catch (e) {
        // pop loader
        Navigator.pop(context);

        // show error message
        displayMessageToUser(
          context,
          "An unexpected error occurred",
          Colors.red,
        );
      }
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

              // username
              Customtextfield(
                hintText: "Username",
                obscureText: false,
                textEditingController: usernameController,
              ),
              // Password
              Customtextfield(
                hintText: "Password",
                obscureText: true,
                textEditingController: passwordController,
              ),

              // Confirm Password field
              Customtextfield(
                hintText: "Confirm Password",
                obscureText: true,
                textEditingController: confirmPasswordController,
              ),

              CustomButton(text: "Register", onPressed: registerUser),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  Text("""Already have an account?"""),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Login",
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
