import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _loginButton(context),
          ],
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      // 카카오 로그인을 위한 메소드
      onTap: () async {
        try {
          bool isAuthenticated = await signInWithKakao(); // 로그인 함수 호출
          if (isAuthenticated) {
            if (!mounted) return;
            context.go('/root'); // 로그인 성공 시 루트 화면으로 이동
          } else {
            print('로그인 실패');
          }
        } catch (error) {
          print('로그인 중 오류 발생: $error');
        }
      },
      child: Image.asset("assets/img/kakao_login_large_wide.png"),
    ),
  );
}

Future<bool> signInWithKakao() async {
  try {
    if (await isKakaoTalkInstalled()) {
      await UserApi.instance.loginWithKakaoTalk();
    } else {
      await UserApi.instance.loginWithKakaoAccount();
    }

    // 로그인 성공 후 사용자 정보 확인
    User user = await UserApi.instance.me();
    print('사용자 정보: ${user.kakaoAccount?.email}');
    return true;
  } catch (error) {
    print('로그인 실패: $error');
    return false;
  }
}
