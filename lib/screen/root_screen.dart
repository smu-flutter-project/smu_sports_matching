import 'package:flutter/material.dart';
import 'package:smu_flutter/screen/map_screen.dart';
import 'package:smu_flutter/screen/meet_screen.dart';
import 'package:smu_flutter/screen/calendar_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: renderChildren(),
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
