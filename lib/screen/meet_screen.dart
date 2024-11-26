import 'package:flutter/material.dart';
import 'package:smu_flutter/screen/components/write_screen.dart';
import 'package:smu_flutter/screen/components/chat_screen.dart';

class MeetScreen extends StatefulWidget {
  const MeetScreen({Key? key}) : super(key: key);

  @override
  State<MeetScreen> createState() => _MeetScreenState();
}

class _MeetScreenState extends State<MeetScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, String>> _teamMeetings = [
    {'title': '11시 축구할 사람', 'subtitle': '축구 모임'},
    {'title': '게시판 제목', 'subtitle': '팀별 프로젝트'},
  ];
  List<Map<String, String>> _individualMeetings = [
    {'title': '11/11 14시 현용찬 회의', 'subtitle': '회의 및 개인 프로젝트'},
    {'title': '11/20 16시 개인 회의', 'subtitle': '프로젝트 회의'},
  ];

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

  void _addMeeting(String title, String subtitle, bool isTeamTab) {
    setState(() {
      if (isTeamTab) {
        _teamMeetings.add({'title': title, 'subtitle': subtitle});
      } else {
        _individualMeetings.add({'title': title, 'subtitle': subtitle});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('모임'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '팀'),
            Tab(text: '개인'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WriteScreen(
                    isTeamTab: _tabController.index == 0,
                    onSave: _addMeeting,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTeamTab(),
          _buildIndividualTab(),
        ],
      ),
    );
  }

  Widget _buildTeamTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _teamMeetings.length,
      itemBuilder: (context, index) {
        final meeting = _teamMeetings[index];
        return _buildMeetingCard(meeting['title']!, meeting['subtitle']!);
      },
    );
  }

  Widget _buildIndividualTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _individualMeetings.length,
      itemBuilder: (context, index) {
        final meeting = _individualMeetings[index];
        return _buildMeetingCard(meeting['title']!, meeting['subtitle']!);
      },
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
            MaterialPageRoute(
              builder: (context) => const ChatScreen(),
            ),
          );
        },
      ),
    );
  }
}