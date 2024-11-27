import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smu_flutter/screen/root_screen.dart';
import 'auth_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smu_flutter/screen/auth_screen.dart';
import 'auth_login.dart';


class Authhome extends StatelessWidget{
  const Authhome({Key? key}) : super (key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context,AsyncSnapshot<User?>snapshot){
          if(!snapshot.hasData){
            return LoginWidget();
          }else{
            return RootScreen();
          }
        },
      ),
    );
  }
}