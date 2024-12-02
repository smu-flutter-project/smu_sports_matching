import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({Key? key}) : super(key: key);

  // 로그아웃 함수
  Future<void> signOutGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await FirebaseAuth.instance.signOut(); // Firebase 로그아웃
      await googleSignIn.signOut(); // Google 로그아웃
      print("User signed out successfully");

      // 로그아웃 후 로그인 화면으로 이동
      Navigator.pushReplacementNamed(context, "/auth");
    } catch (e) {
      print("Error during sign-out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during logout: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        onPressed: () => signOutGoogle(context),
        child: const Text(
          "Logout",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
