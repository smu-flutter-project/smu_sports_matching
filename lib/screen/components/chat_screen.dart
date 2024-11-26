import 'package:flutter/material.dart';

// 채팅 화면
class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10, // 메시지 수
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Message $index'),
                  subtitle: Text('Content of message $index'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: '메시지 입력',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    // 메시지 전송 로직
                  },
                  child: const Text('전송하기'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
