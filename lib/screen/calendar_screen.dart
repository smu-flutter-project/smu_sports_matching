import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SportsFacility {
  final String name;
  final String type;
  final String address;
  final String image;

  SportsFacility({
    required this.name,
    required this.type,
    required this.address,
    required this.image,
  });
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentDate = DateTime.now();

  List<SportsFacility> facilities = [
    SportsFacility(
        name: '수영장',
        type: '실내 / 수영',
        address: '충남 천안시 동남구 상명대길 31 스포츠센터 1층',
        image: 'assets/img/swimming_pool.png'),
    SportsFacility(
        name: '스쿼시장',
        type: '실내 / 스쿼시',
        address: '충남 천안시 동남구 상명대길 31 스포츠센터 1층',
        image: 'assets/img/squash_court.png'),
    SportsFacility(
        name: '댄스 스튜디오',
        type: '실내 / 무용',
        address: '충남 천안시 동남구 상명대길 31 스포츠센터 3층',
        image: 'assets/img/dance.png'),
    SportsFacility(
        name: '스크린골프장',
        type: '실내 / 골프',
        address: '충남 천안시 동남구 상명대길 31 스포츠센터 1층',
        image: 'assets/img/screen_golf.png'),
    SportsFacility(
        name: '운동장',
        type: '야외 / 축구,풋살',
        address: '충남 천안시 동남구 상명대길 31 운동장',
        image: 'assets/img/play_ground.png'),
    SportsFacility(
        name: '농구',
        type: '야외 / 농구',
        address: '충남 천안시 동남구 상명대길 31 농구장',
        image: 'assets/img/basketball.png'),
    SportsFacility(
        name: '헬스장',
        type: '실내 / 웨이트',
        address: '충남 천안시 동남구 상명대길 31 스포츠센터',
        image: 'assets/img/health_club.png'),
    SportsFacility(
        name: '체육관',
        type: '기타',
        address: '충남 천안시 동남구 상명대길 31 계당관',
        image: 'assets/img/gym.png'),
  ];

  List<DateTime> _getWeekDates(DateTime date) {
    return [
      date.subtract(Duration(days: 2)),
      date.subtract(Duration(days: 1)),
      date,
      date.add(Duration(days: 1)),
      date.add(Duration(days: 2)),
    ];
  }

  void _navigateToNextScreen(
      String facilityName, String facilityAddress, String facilityImage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarScreen2(
          facilityName: facilityName,
          facilityAddress: facilityAddress,
          facilityImage: facilityImage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDates = _getWeekDates(_currentDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '시설 안내',
          style: TextStyle(
            fontWeight: FontWeight.bold,  // Set the font weight to bold
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/main_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.srcATop,
            ),
          ),
        ),
        child: Column(
          children: [
            Container(
              color: Colors.white.withOpacity(1),
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    alignment: Alignment.center,
                    child: Text(
                      '${DateFormat('MM').format(_currentDate)}월',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: weekDates.map((date) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentDate = date;
                            });
                          },
                          child: Column(
                            children: [
                              SizedBox(height: 4),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: date.day == _currentDate.day
                                      ? Colors.red
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: date.day == _currentDate.day
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),  // Add 10px pdding on left and right
                  child: ListView.builder(
                    itemCount: facilities.length,
                    itemBuilder: (context, index) {
                      final facility = facilities[index];

                      return Container(
                        width: 200,
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),  // Set the background color to white with 60% opacity
                          borderRadius: BorderRadius.circular(30),  // Apply a border radius of 20
                          border: Border.all(
                            color: Colors.white.withOpacity(0.8),  // Set the border color with trfnspfrency
                            width: 10,  // Set the border thickness to 10
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),  // Add horizontal padding of 20 and vertical padding of 10
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(facility.name),
                              subtitle: Text(facility.type),
                              onTap: () {
                                _navigateToNextScreen(facility.name, facility.address, facility.image);
                              },
                            ),
                            Divider(
                              color: Colors.black,  // Color of the line
                              thickness: 1,  // Thickness of the line
                              height: 10,  // Height of the divider (space between ListTile items)
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CalendarScreen2 extends StatefulWidget {
  final String facilityName;
  final String facilityAddress;
  final String facilityImage;

  const CalendarScreen2({
    Key? key,
    required this.facilityName,
    required this.facilityAddress,
    required this.facilityImage,
  }) : super(key: key);

  @override
  State<CalendarScreen2> createState() => _CalendarScreen2State();
}

class _CalendarScreen2State extends State<CalendarScreen2> {
  double _progress = 0;
  int _clickCount = 0;

  String getClickCountText() {
    return '$_clickCount 명이 희망하고 있어요!!!!';
  }

  void _incrementProgress() {
    setState(() {
      _progress = (_progress + 0.033).clamp(0.0, 1.0);
      _clickCount++;
    });
  }

  void _showGuideDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('이용안내'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '1. 이용대상: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '재학생, 교직원(동반 가족 포함)',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '2. 사용료: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '무료',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '3. 이용방법: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '실내 시설은 안내 데스크에서 학생증 제시 후 입장 가능.',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '4. 운영내용: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Image.asset(
                  'assets/img/information.png',
                  height: 150,
                  width: 300,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }  void _showRulesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('이용규칙'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '1. 공지: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '예약 과정에서 이용하려는 스포츠 종목 또는 목적을 꼭 적어주세요.',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '2. 예약 가능 일자: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '일정 확인 후 예약 없는 날짜에 예약 가능',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '3. ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text:
                          '학교 사정으로 인해 예약이 취소 될수도 있으며, 이 경우 전액 환불 조치 외에 다른 보상이 제공되지 않습니다.',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.facilityName),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(widget.facilityImage),
              SizedBox(height: 40),
              Text(
                "희망 인기도",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                getClickCountText(),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Stack(
                children: [
                  LinearProgressIndicator(
                    value: _progress,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "다양한 사람들과 같이 즐겨보아요!",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _incrementProgress,
                child: Text(
                  '희망해요!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
              SizedBox(height: 40),
              Text(
                '구장 정보',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.facilityAddress,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _showGuideDialog,
                    child: Text('이용안내'),
                  ),
                  ElevatedButton(
                    onPressed: _showRulesDialog,
                    child: Text('이용규칙'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
