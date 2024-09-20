import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewExWidget extends StatelessWidget {
  final commentvalue = TextEditingController();
  var user = FirebaseAuth.instance.currentUser;
  String name = 'undefined';
// final rat = TextEditingController();
  final Function callBackFunc;
  String post_id;

  NewExWidget({required this.callBackFunc, required this.post_id});

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Comment'),
            controller: commentvalue,
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user?.uid)
                  .get()
                  .then((DocumentSnapshot ds) {
                if (ds.exists) {
                  print('ana heeeeeeeeeeena');
                  name = ds["username"];
                } else {
                  print('Document does not exist');
                }
              });
              print('dah el name');
              print(name);
              callBackFunc(
                  comment: commentvalue.text,
                  user_id: user?.uid,
                  user_name: name,
                  user_email: user?.email,
                  post_id: post_id);
            },
            child: Text(
              "submit",
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
