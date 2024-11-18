import 'package:flutter/material.dart';


// 글쓰기 화면
class WriteScreen extends StatelessWidget {
  const WriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('글 쓰기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: '팀 모집 내용 입력',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // 글쓰기 저장 로직 구현
                Navigator.pop(context);
              },
              child: const Text('완료'),
            ),
          ],
        ),
      ),
    );
  }
}