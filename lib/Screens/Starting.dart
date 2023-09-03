import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_note_24_july_2023/Screens/Home.dart';
import 'package:google_note_24_july_2023/Screens/Splash.dart';
import 'package:google_sign_in/google_sign_in.dart';
class Starting extends StatefulWidget{
  const Starting({super.key});

  @override
  State<Starting> createState() => _StartingState();
}

class _StartingState extends State<Starting> {
  final googleSignIn=GoogleSignIn();
  @override
  void initState() {
    check();
    super.initState();
  }
  void check()async{
    if(await googleSignIn.isSignedIn()) {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
      });
    }else{
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Splash()));
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final mediaQuery=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: mediaQuery.height*1,
        width: mediaQuery.width*1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/pen.png'),
            const Text('Keep Notes',style: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}