import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import "package:smu_flutter/const/colors.dart";
import 'package:smu_flutter/screen/root_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smu_flutter/screen/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  KakaoSdk.init(
    nativeAppKey: 'f9c1e16c94d91d362dd9a139399b6e9f',
    javaScriptAppKey: 'c3f425e1eacbdf343ddbc9093ca24c30',
  );

  await Firebase.initializeApp();

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