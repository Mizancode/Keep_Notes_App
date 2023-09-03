import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_note_24_july_2023/utils/Toast.dart';
import 'package:intl/intl.dart';
// ignore: must_be_immutable
class AddNotes extends StatelessWidget{
  final auth=FirebaseAuth.instance;
  final headingController=TextEditingController();
  final contentController=TextEditingController();
  var time=DateTime.now();

  AddNotes({super.key});
  @override
  Widget build(BuildContext context) {
    final firebaseStore=FirebaseFirestore.instance.collection(auth.currentUser!.email.toString());
    addNote(){
      var id=DateTime.now().millisecondsSinceEpoch.toString();
      firebaseStore.doc(id).set({
        'ID':id,
        'Heading':headingController.text.toString(),
        'Content':contentController.text.toString(),
        'Date':'${time.day}/${time.month}/${time.year}'
      }).then((value){
        Toast.toastMessage('Note Added Successfully');
        Navigator.of(context).pop();
      }).catchError((e){
        Toast.toastMessage(e.toString());
      });
    }
    final mediaQuery=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
        ),
        actions: [
          IconButton(
              onPressed: (){
                addNote();
              }, icon: const Icon(Icons.save,color: Colors.white,)
          )
        ],
      ),
      body: SizedBox(
        height: mediaQuery.height,
        width: mediaQuery.width,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              alignment: Alignment.centerLeft,
              child: Text('${time.day}/${time.month}/${time.year}, ${DateFormat('Hm').format(time)}',style: const TextStyle(color: Colors.grey,fontSize: 14),),
            ),
            Divider(thickness: 1,color: Colors.grey.shade800,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextFormField(
                controller: headingController,
                cursorColor: Colors.amber,
                style: const TextStyle(color: Colors.white,fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Heading',
                  hintStyle: TextStyle(color: Colors.grey.shade600,fontSize: 16),
                  border: InputBorder.none
                ),
              ),
            ),
            Divider(thickness: 1,color: Colors.grey.shade800,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextFormField(
                controller: contentController,
                cursorColor: Colors.amber,
                style: const TextStyle(color: Colors.white,fontSize: 18),
                maxLines: 20,
                decoration: InputDecoration(
                    hintText: 'Content',
                    hintStyle: TextStyle(color: Colors.grey.shade600,fontSize: 16),
                    border: InputBorder.none
                ),
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}