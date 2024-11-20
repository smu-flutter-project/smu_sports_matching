import 'package:flutter/material.dart';
import 'package:smu_flutter/const/colors.dart';
import 'package:table_calendar/table_calendar.dart';
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
        image: 'assets/img/gym.png')

  ];

  // 특정 주간의 날짜 계산

  List<DateTime> _getWeekDates(DateTime date) {
    return [
      date.subtract(Duration(days: 2)),
      date.subtract(Duration(days: 1)),
      date,
      date.add(Duration(days: 1)),
      date.add(Duration(days: 2)),
    ];
  }

  void _navigateToNextScreen(String facilityName, String facilityAddress,String facilityImage) {
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
        title: Text(''),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                // 왼쪽에 월 표시 (숫자로)

                Container(
                  width: 60,
                  alignment: Alignment.center,
                  child: Text(
                    '${DateFormat('MM').format(_currentDate)}월',
                    // 월 (숫자, 예: 01)

                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // 오른쪽에 날짜 5개 표시

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
                                '${date.day}', // 날짜

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
            child: ListView.builder(
              itemCount: facilities.length,
              itemBuilder: (context, index) {
                final facility = facilities[index];

                return ListTile(
                  title: Text(facility.name),

                  subtitle: Text(facility.type), // 경기장 종류 추가

                  onTap: () {
                    _navigateToNextScreen(facility.name, facility.address,facility.image);
                  },
                );
              },
            ),
          ),
        ],
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
    required this.facilityImage
  }) : super(key: key);

  @override
  State<CalendarScreen2> createState() => _CalendarScreen2State();
}

class _CalendarScreen2State extends State<CalendarScreen2> {
  double _progress = 0;
  int _clickCount = 0; // 버튼 클릭 횟수 저장 변수

  String getClickCountText() {
    return '$_clickCount 명이 희망하고 있어요!!!!'; // 버튼 클릭 횟수만 표시
  }

  void _incrementClickCount() {
    setState(() {
      _clickCount++; // 버튼 클릭 시 횟수 증가
    });
  }

  static const int totalDivisions = 30; // 총 30단계로 변경

  // 한 칸에 해당하는 진행률 값
  double _progressIncrement = 1 / totalDivisions;

  void _incrementProgress() {
    setState(() {
      _progress += _progressIncrement;
      // 진행률이 1을 넘지 않도록 제한
      _progress = _progress.clamp(0.0, 1.0);
      _clickCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.facilityName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(widget.facilityImage),

            SizedBox(height: 40),
            // 희망 인기도 표시
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

            // 진행률 표시
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

            // 구장 정보 섹션
            Text(
              '구장 정보',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),

            // 기존 구장 정보
            Text(
              widget.facilityAddress,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),

            // 추가된 주소 정보
            SizedBox(height: 30),

            Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red[400],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '이용안내',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
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
                        text: '실내를 이용해야하는 시설의 경우 안내 ',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: '데스크에서 학생증 제시후 입장(이용)가능 ',
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: '안내 데스크가 없는 야외의 경우 관리팀에 문의하여 대관',
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final int divisions; // 구분선 개수

  final double width; // 각 구분선의 너비

  GridPainter({required this.divisions, required this.width});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0;

    // 1번째 구분선부터 (0번째는 제외) divisions - 1 까지 선 그리기

    for (int i = 1; i < divisions; i++) {
      canvas.drawLine(
        Offset(i * width, 0), // 시작점 (구분선 위치, 0)

        Offset(i * width, size.height), // 끝점 (구분선 위치, 높이 전체)

        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
