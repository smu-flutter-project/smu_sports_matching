import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 여기서 로그인 로직을 구현하세요.
            bool isAuthenticated = true; // 예시로 성공 여부를 true로 설정

            if (isAuthenticated) {
              context.go('/root'); // 로그인 성공 시 `RootScreen`으로 이동
            }
          },
          child: Text("Login"),
        ),
      ),
    );
  }
}