import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_note_24_july_2023/Screens/Starting.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyMain());
}
class MyMain extends StatelessWidget{
  const MyMain({super.key});

  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Starting(),
    );
  }
}