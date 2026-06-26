import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coffee_and_tea/components/google_login.dart';
import 'package:flutter_coffee_and_tea/components/my_button.dart';
import 'package:flutter_coffee_and_tea/components/my_textfield.dart';
import 'package:flutter_coffee_and_tea/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key,
    required this.onTap
  });

  final Function()? onTap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();

}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signWithGoogle() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    AuthService().signInWithGoogle();
    Navigator.pop(context);
  }

  void signupUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      if (confirmPasswordController.text == passwordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }else{
        Navigator.pop(context);
        showErrormessage('Passwords do not match!');
      }
    }on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      showErrormessage(e.code);
    }
  }

  void showErrormessage(String errorMessage){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registration Failed'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3E4C9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                // logo
                Icon(Icons.lock, size: 50),
                SizedBox(height: 50),
                // welcome back
                Text(
                  'Let create a new account!',
                  style: TextStyle(fontSize: 25, color: Colors.grey[900]),
                ),
                SizedBox(height: 25),
                // email textfield
                MyTextfield(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                SizedBox(height: 25),
                // password textfield
                MyTextfield(
                  controller: passwordController,
                  hintText: 'New password',
                  obscureText: true,
                ),
                SizedBox(height: 25),
                // password textfield
                MyTextfield(
                  controller: confirmPasswordController,
                  hintText: 'Confirm password',
                  obscureText: true,
                ),
                SizedBox(height: 20),
                // forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [Text('Forgot password?')],
                  ),
                ),
                // sign in
                MyButton(onTap: signupUser, buttonTitle: 'Register',),
                // continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 0.5, color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Continue with',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 0.5, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                // google sign in
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [SquareTile(
                    imagePath: 'assets/google_logo.png', 
                    onTap: signWithGoogle,
                  )],
                ),
                // register
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
