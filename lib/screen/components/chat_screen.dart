import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao_sdk;
import 'package:flutter/services.dart';

class ChatScreen extends StatelessWidget {
  final String chatRoomId;

  const ChatScreen({Key? key, required this.chatRoomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _messageController = TextEditingController();
    final firebase_auth.User? currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
    String? kakaoNickname;

    Future<void> fetchKakaoNickname() async {
      try {
        kakao_sdk.User user = await kakao_sdk.UserApi.instance.me();
        kakaoNickname = user.kakaoAccount?.profile?.nickname;
        print("카카오 닉네임: $kakaoNickname");
      } catch (e) {
        print("카카오 닉네임 가져오기 실패: $e");
        kakaoNickname = "Unknown";
      }
    }

    void sendMessage() async {
      if (_messageController.text.trim().isEmpty) return;

      // Ensure kakaoNickname is fetched before sending the message
      if (kakaoNickname == null) {
        await fetchKakaoNickname();
      }

      await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .add({
        'sender': kakaoNickname ?? currentUser?.email ?? 'Unknown',
        'message': _messageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
    }

    // Paste text from the system clipboard into the message input field
    void pasteFromClipboard() async {
      ClipboardData? clipboardData = await Clipboard.getData('text/plain');
      if (clipboardData != null) {
        _messageController.text = clipboardData.text ?? '';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatRooms')
                  .doc(chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message['sender']),
                      subtitle: Text(message['message']),
                    );
                  },
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
                IconButton(
                  icon: const Icon(Icons.paste),
                  onPressed: pasteFromClipboard,
                  tooltip: 'Paste from clipboard',
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: sendMessage,
                  child: const Text('전송'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}