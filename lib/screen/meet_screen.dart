import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smu_flutter/screen/components/write_screen.dart';
import 'package:smu_flutter/screen/components/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MeetScreen extends StatefulWidget {
  const MeetScreen({Key? key}) : super(key: key);

  @override
  State<MeetScreen> createState() => _MeetScreenState();
}

class _MeetScreenState extends State<MeetScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, String>> _teamMeetings = [];
  List<Map<String, String>> _individualMeetings = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchMeetings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchMeetings() async {
    final teamSnapshot = await FirebaseFirestore.instance
        .collection('meetings')
        .where('type', isEqualTo: 'team')
        .get();

    final individualSnapshot = await FirebaseFirestore.instance
        .collection('meetings')
        .where('type', isEqualTo: 'individual')
        .get();

    // setState와 map함수를 사용하여 나열
    setState(() {
      _teamMeetings = teamSnapshot.docs
          .map((doc) => {
                'title': doc['title'] as String,
                'subtitle': doc['subtitle'] as String,
              })
          .toList();

      _individualMeetings = individualSnapshot.docs
          .map((doc) => {
                'title': doc['title'] as String,
                'subtitle': doc['subtitle'] as String,
              })
          .toList();
    });
  }

  Future<void> _addMeeting(
      String title, String subtitle, bool isTeamTab) async {
    final type = isTeamTab ? 'team' : 'individual';

    await FirebaseFirestore.instance.collection('meetings').add({
      'title': title,
      'subtitle': subtitle,
      'type': type,
    });

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
            title: const Text(
              '모임',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white,
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: '팀'),
                Tab(text: '개인'),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  await GoogleSignIn().signOut();
                  Navigator.pushReplacementNamed(context, "/auth");
                },
              ),
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
            ]
        ),

        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTeamTab(),
            _buildIndividualTab(),
          ],
        )
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
      color: Colors.white,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // 고유 chatRoomId 생성
          final chatRoomId = title.hashCode.toString();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(chatRoomId: chatRoomId),
            ),
          );
        },
      ),
    );
  }
}
