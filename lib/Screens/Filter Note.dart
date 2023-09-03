import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_note_24_july_2023/Screens/Edit%20Notes.dart';
import 'package:google_note_24_july_2023/utils/Toast.dart';
class FilterNote extends StatefulWidget{
  const FilterNote({super.key});

  @override
  State<FilterNote> createState() => _FilterNoteState();
}

class _FilterNoteState extends State<FilterNote> {
  final auth=FirebaseAuth.instance;
  TextEditingController searchController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    final firebaseStore=FirebaseFirestore.instance.collection(auth.currentUser!.email.toString());
    final firebaseRef=FirebaseFirestore.instance.collection(auth.currentUser!.email.toString()).snapshots();
    final mediaQuery=MediaQuery.of(context).size;
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
          height: mediaQuery.height,
          width: mediaQuery.width,
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                            autofocus: true,
                            onChanged: (value){
                              setState(() {

                              });
                            },
                            controller: searchController,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16
                            ),
                            cursorColor: Colors.amber,
                        decoration: const InputDecoration(
                          hintText: 'Search notes',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 18
                          ),
                          border: InputBorder.none
                        ),
                      )),
                      TextButton(
                          onPressed: (){
                             Navigator.of(context).pop();
                          },
                          child: const Text('Cancel',style: TextStyle(color: Colors.amber,fontSize: 16),),
                      )
                    ],
                  ),
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
                            if(searchController.text.toString().isEmpty){
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
                            }
                            else if(snapshot.data!.docs[index]['Heading'].toString().contains(searchController.text.toString())){
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
                            }else{
                              return Container();
                            }
                          }),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}