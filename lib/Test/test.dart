import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState()=> _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Image.asset('lib/Assets/1x/Asset 2.png',
          fit: BoxFit.cover,)
        ),
        Center(
          child: Padding(padding: EdgeInsets.all(50.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white
            ),

          ))
        )
      ],
    );
    
  }
}