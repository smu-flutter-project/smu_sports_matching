import 'package:flutter/material.dart';
import 'dart:math';
import 'package:smu_flutter/screen/map_screen.dart';
import 'package:smu_flutter/screen/meet_screen.dart';
import 'package:smu_flutter/screen/calendar_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase 인증
import 'package:google_sign_in/google_sign_in.dart'; // Google 로그아웃

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    controller!.addListener(tabListener);
  }

  tabListener() {
    setState(() {});
  }

  @override
  void dispose() {
    controller!.removeListener(tabListener); // Listener 제거
    controller!.dispose(); // Controller 해제
    super.dispose();
  }

  // 로그아웃 함수
  Future<void> signOutGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await FirebaseAuth.instance.signOut(); // Firebase 로그아웃
      await googleSignIn.signOut(); // Google 계정 로그아웃
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
    return Scaffold(
      appBar: AppBar(
        actions: [
          // 로그아웃 버튼 추가
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await signOutGoogle(); // 로그아웃 실행
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(), // 드래그 비활성화
        children: renderChildren(), // 각 탭에 해당하는 화면 반환
      ),
      bottomNavigationBar: renderBottomNavigation(),
    );
  }

  // 각 탭에 연결될 화면들
  List<Widget> renderChildren() {
    return [
      const CalendarScreen(), // 달력
      const MapScreen(), // 지도 페이지!
      const MeetScreen(), // 모임
    ];
  }

  // BottomNavigationBar
  BottomNavigationBar renderBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: controller!.index,
      onTap: (int index) {
        setState(() {
          controller!.animateTo(index);
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: '달력',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: '지도',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: '모임',
        ),
      ],
    );
  }
}
