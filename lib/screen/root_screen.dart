import 'package:flutter/material.dart';
import 'dart:math';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  TabController? controller; // 사용할 TabController 선언


  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this); // ➋
    controller!.addListener(tabListener);
  }



  tabListener() {
    setState(() {});
  }

  @override
  void dispose() {
    controller!.removeListener(tabListener); // ➌ listener에 등록한 함수 등록 취소
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller,
        children: renderChildren(),
      ),
      bottomNavigationBar: renderBottomNavigation(),
    );
  }

  List<Widget> renderChildren() {
    return [

    ];
  }



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
          icon: Icon(
            Icons.location_on,
          ),
          label: '위치',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.calendar_month,
          ),
          label: '일정',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.group,
          ),
          label: '모임임',
        ),
      ],
    );
  }
}