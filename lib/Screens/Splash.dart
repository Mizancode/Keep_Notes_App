// ignore_for_file: constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_note_24_july_2023/Screens/Home.dart';
import 'package:google_note_24_july_2023/utils/Toast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
class Splash extends StatefulWidget{
  const Splash({super.key});

  @override
  State<Splash> createState() => SplashState();
}
class SplashState extends State<Splash> {
  static const String KEYNAME='login';
  final auth=FirebaseAuth.instance;
  final googleSign=GoogleSignIn();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    void googleSignUp()async{
      GoogleSignInAccount? googleSignInAccount=await googleSign.signIn();
      GoogleSignInAuthentication googleSignInAuthentication=await googleSignInAccount!.authentication;
      final credential=GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      auth.signInWithCredential(credential).then((value){
        Toast.toastMessage(value.user!.email.toString());
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
      }).catchError((e){
        Toast.toastMessage(e.toString());
      });
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Image.asset('assets/images/pen.png',),
            const Text('Keep Notes',style: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold),),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.02,
            ),
            SizedBox(
              height: 40,
              child: Center(
                  child: SignInButton(
                    Buttons.google,
                    text: "Sign up with Google",
                    onPressed: () {
                      googleSignUp();
                    },
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}