import 'package:flutter/material.dart';

// WriteScreen: 글쓰기 화면
class WriteScreen extends StatefulWidget {
  const WriteScreen({
    Key? key,
    required this.onSave,
    required this.isTeamTab,
  }) : super(key: key);

  final Function(String title, String subtitle, bool isTeamTab) onSave;
  final bool isTeamTab;

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('글 쓰기'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: widget.isTeamTab ? '팀 모집 내용 입력' : '개인 일정 입력',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  widget.onSave(
                    _textController.text,
                    widget.isTeamTab ? '새로운 팀 모집' : '새로운 개인 일정',
                    widget.isTeamTab,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('완료',style: TextStyle(
                color: Colors.black,

              ),
              ),style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // 배경색을 흰색으로 설정
            ),
            ),
          ],
        ),
      ),
    );
  }
}