import 'package:flutter/material.dart';
import 'package:flutter_coffee_and_tea/pages/login_page.dart';
import 'package:flutter_coffee_and_tea/pages/register_page.dart';

class LoginOrRegistered extends StatefulWidget {
  const LoginOrRegistered({super.key});

  @override
  State<LoginOrRegistered> createState() => _LoginOrRegisteredState();
}

class _LoginOrRegisteredState extends State<LoginOrRegistered> {
  bool showRegisterPage = true; 

  void togglePage(){
    setState(() {
      showRegisterPage = !showRegisterPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showRegisterPage){
      return LoginPage(
        onTap: togglePage,
      );
    }else{
      return RegisterPage(onTap: togglePage);
    }
  }
}