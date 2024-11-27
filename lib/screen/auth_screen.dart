import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth_home.dart';

class AuthScreen extends StatelessWidget{
  const AuthScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return FutureBuilder(future: Firebase.initializeApp(),
        builder:(context,snapshot){
          if(snapshot.hasError){
            return Center(
              child: Text("error"),
            );
          }
          if(snapshot.connectionState==ConnectionState.done){
            return Authhome();
          }
          return CircularProgressIndicator();
        }

    );
  }
}