import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LogoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/logo.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    bool isAuthenticated = true;

                    if (isAuthenticated) {
                      context.go('/login');
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
