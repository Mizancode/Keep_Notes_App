import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_note_24_july_2023/Screens/Splash.dart';
import 'package:google_sign_in/google_sign_in.dart';
class MyDrawer extends StatelessWidget{
  final auth=FirebaseAuth.instance;
  final googleSignOut=GoogleSignIn();

  MyDrawer({super.key});
  signOut(){
    googleSignOut.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
     backgroundColor: Colors.grey.shade800,
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                accountName: Text(auth.currentUser!.displayName.toString()),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                ),
                accountEmail: Text(auth.currentUser!.email.toString()),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(auth.currentUser!.photoURL.toString().toString()),
                ),
              )
          ),
          const Divider(thickness: 0.2,color: Colors.white,),
          const ListTile(
            leading: Icon(Icons.home,color: Colors.white,size: 20,),
            title: Text('Home',style: TextStyle(color: Colors.white,fontSize: 15),),
          ),
          const Divider(thickness: 0.2,color: Colors.white,),
          const ListTile(
            leading: Icon(CupertinoIcons.profile_circled,color: Colors.white,size: 20,),
            title: Text('Profile',style: TextStyle(color: Colors.white,fontSize: 15),),
          ),
          const Divider(thickness: 0.2,color: Colors.white,),
          const ListTile(
            leading: Icon(Icons.email_outlined,color: Colors.white,size: 20,),
            title: Text('Email',style: TextStyle(color: Colors.white,fontSize: 15),),
          ),
          const Divider(thickness: 0.2,color: Colors.white,),
          ListTile(
            onTap: (){
              signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Splash()));
            },
            leading: const Icon(Icons.logout,color: Colors.white,size: 20,),
            title: const Text('LogOut',style: TextStyle(color: Colors.white,fontSize: 15),),
          ),
          const Divider(thickness: 0.2,color: Colors.white,),
        ],
      ),
    );
  }
}