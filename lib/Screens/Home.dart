import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_note_24_july_2023/Screens/Add%20Notes.dart';
import 'package:google_note_24_july_2023/Screens/Edit%20Notes.dart';
import 'package:google_note_24_july_2023/Screens/Filter%20Note.dart';
import 'package:google_note_24_july_2023/Screens/GridView.dart';
import 'package:google_note_24_july_2023/Widget/Drawer.dart';
import 'package:google_note_24_july_2023/utils/Toast.dart';
class Home extends StatelessWidget{
  final auth=FirebaseAuth.instance;
  static int count=0;
  Home({super.key});
  @override
  Widget build(BuildContext context) {
    final firebaseStore=FirebaseFirestore.instance.collection(auth.currentUser!.email.toString());
    final firebaseRef=FirebaseFirestore.instance.collection(auth.currentUser!.email.toString()).snapshots();
    final mediaQuery=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            splashRadius: 20,
              onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const FilterNote()));
              }, icon: const Icon(Icons.search,color: Colors.white,)
          ),
         PopupMenuButton(
           color: Colors.transparent,
           icon: const Icon(Icons.more_vert,color: Colors.white,),
           itemBuilder: (context)=>[
             PopupMenuItem(
              child: ListTile(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GridScreen()));
                },
                title: const Text('Grid View',style: TextStyle(color: Colors.white),),
                leading: const Icon(Icons.grid_on,color: Colors.white,),
              )
          )
        ],
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
              child: const Text('All notes',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 35),),
            ),
            SizedBox(height: mediaQuery.height*0.007,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              alignment: Alignment.centerLeft,
              child: Text('$count notes',style: const TextStyle(color: Colors.grey,fontSize: 16),),
            ),
            SizedBox(height: mediaQuery.height*0.02,),
            StreamBuilder<QuerySnapshot>(
              stream: firebaseRef,
              builder: (content,AsyncSnapshot<QuerySnapshot>snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return const CircularProgressIndicator();
                }
                if(snapshot.hasError){
                  return Toast.toastMessage('Some Error Occurred');
                }
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        count=snapshot.data!.docs.length;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListTile(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>EditNotes(snapshot.data!.docs[index]['ID'].toString(),snapshot.data!.docs[index]['Heading'].toString(),snapshot.data!.docs[index]['Content'].toString())));
                            },
                            onLongPress: (){
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      icon: const Icon(Icons.delete,color: Colors.black,size: 35,),
                                      title: const Text('Are You Sure Want to Delete'),
                                      actions: [
                                        TextButton(
                                            onPressed: (){
                                              Navigator.of(context).pop();
                                            }, child: const Text('Cancel')),
                                        TextButton(onPressed: (){
                                          Navigator.of(context).pop();
                                          firebaseStore.doc(snapshot.data!.docs[index]['ID'].toString()).delete();
                                        }, child: const Text('Delete'))
                                      ],
                                    );
                                  }
                              );
                            },
                            title: Text(snapshot.data!.docs[index]['Heading'].toString(),style: const TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,maxLines: 1,),
                            subtitle: Text(snapshot.data!.docs[index]['Date'].toString(),style: const TextStyle(color: Colors.white38),),
                          ),
                        );
                      }),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNotes()));
        },
        child: const Icon(Icons.add,color: Colors.white,),
      ),
        drawer:MyDrawer()
    );
  }
}