import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<String> _messages = []; // 메시지 기록을 저장

  @override
  void initState() {
    super.initState();
    _loadMessages(); // 화면 로드 시 메시지 불러오기
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // 메시지를 로컬에 저장
  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesKey = 'messages_${widget.chatId}';
    await prefs.setString(messagesKey, jsonEncode(_messages));
  }

  // 로컬에 저장된 메시지를 불러오기
  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesKey = 'messages_${widget.chatId}';
    final savedMessages = prefs.getString(messagesKey);

    if (savedMessages != null) {
      setState(() {
        _messages = List<String>.from(jsonDecode(savedMessages));
      });
    }
  }

  // 메시지 전송
  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(message); // 메시지 추가
        _messageController.clear(); // 입력 필드 초기화
      });
      _saveMessages(); // 메시지 저장
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅 - ${widget.chatId}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('사용자: ${_messages[index]}'), // 메시지 출력
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
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: '메시지 입력',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _sendMessage,
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