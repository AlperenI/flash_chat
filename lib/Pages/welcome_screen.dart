// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api



import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chatt/Pages/login_screen.dart';
import 'package:flash_chatt/Pages/registration_screen.dart';
import 'package:flash_chatt/comp/rounded_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static String id="welcome_screen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    super.initState();
    controller=AnimationController(duration:Duration(seconds: 3),vsync: this,);
    controller.forward();
    animation=ColorTween(begin: Colors.red,end:Colors.blue).animate(controller);
    controller.addListener((){
      setState(() {
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:[
            Row(
              children:[
                Hero(tag:"logo" ,
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height:60,
                  ),
                ),
                AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts:[
                    TypewriterAnimatedText(
                      speed: Duration(milliseconds: 70),
                      "Flash Chat",textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                  )
                  ],
                  
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(colour: Colors.lightBlue,title:"Log In",onPressed: () {
              Navigator.pushNamed(context, LoginScreen.id);
            },),
            RoundedButton(colour: Colors.blueAccent, onPressed: (){
              Navigator.pushNamed(context,RegistrationScreen.id);
            }, title:"Register")
          ],
        ),
      ),
    );
  }
}

