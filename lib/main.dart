import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import "package:smu_flutter/const/colors.dart";
import 'package:smu_flutter/screen/root_screen.dart';
import 'package:smu_flutter/screen/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smu_flutter/firebase_options.dart';
import 'package:smu_flutter/screen/logo_screen.dart';
import 'package:smu_flutter/screen/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //
  // // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  // WidgetsFlutterBinding.ensureInitialized();
  // // runApp() 호출 전 Flutter SDK 초기화
  // KakaoSdk.init(
  //   nativeAppKey: '28352c19e374b93489a539774edbd01f'
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: primaryColor,
          unselectedItemColor: secondaryColor,
          backgroundColor: bottombackgroundColor,
        ),
      ),
    );
  }

  final GoRouter _router = GoRouter(
    initialLocation: '/auth',
    routes: [
      GoRoute(
        path: '/logo',
        builder: (context, state) => LogoScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => AuthScreen(),
      ),
      GoRoute(
        path: '/root',
        builder: (context, state) => RootScreen(),
      ),
    ],
  );
}