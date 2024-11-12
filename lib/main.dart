import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import "package:smu_flutter/const/colors.dart";
import 'package:smu_flutter/screen/root_screen.dart';
import 'package:smu_flutter/screen/login_screen.dart';

void main() {
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
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/root',
        builder: (context, state) => RootScreen(),
      ),
    ],
  );
}