import 'package:flutter/material.dart';
import 'package:smu_flutter/screen/components/write_screen.dart';
import 'package:smu_flutter/screen/components/chat_screen.dart';

class MeetScreen extends StatefulWidget {
  const MeetScreen({Key? key}) : super(key: key);

  @override
  State<MeetScreen> createState() => _MeetScreenState();
}

class _MeetScreenState extends State<MeetScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('모임'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '팀'),
            Tab(text: '개인'),
          ],
        ),
        actions: [
          IconButton( // 글쓰기 버튼
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(  // 글쓰기 화면으로 전환
                  builder: (context) => const WriteScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 팀 화면
          _buildTeamTab(),
          // 개인 화면
          _buildIndividualTab(),
        ],
      ),
    );
  }

  Widget _buildTeamTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildMeetingCard('11시 축구할 사람', '축구 모임'),
        _buildMeetingCard('게시판 제목', '팀별 프로젝트'),
        _buildMeetingCard('게시판 제목', '워크샵 팀 구성'),
        _buildMeetingCard('게시판 제목', '운동 그룹 모집'),
      ],
    );
  }

  Widget _buildIndividualTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildMeetingCard('11/11 14시 현용찬 회의', '회의 및 개인 프로젝트'),
        _buildMeetingCard('11/20 16시 개인 회의', '프로젝트 회의'),
        _buildMeetingCard('12/01 13시 개인 PT', 'PT 세션 예약'),
        _buildMeetingCard('12/05 10시 자율 회의', '개인 일정 관리'),
      ],
    );
  }

  Widget _buildMeetingCard(String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute( // 채팅 화면으로 이동
              builder: (context) => const ChatScreen(),
            ),
          );
        },
      ),
    );
  }
}

