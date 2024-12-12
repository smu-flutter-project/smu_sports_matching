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
    final firebase_auth.User? currentUser =
        firebase_auth.FirebaseAuth.instance.currentUser;
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

    void pasteFromClipboard() async {
      ClipboardData? clipboardData = await Clipboard.getData('text/plain');
      if (clipboardData != null) {
        _messageController.text = clipboardData.text ?? '';
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar 배경색을 흰색으로 설정
        title: const Text(
          '채팅',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black, // 텍스트 색을 검정으로 설정 (기본적으로 흰색 배경에 검정색 텍스트가 보임)
          ),
        ),
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
                    final isCurrentUser = (message['sender'] ==
                        (kakaoNickname ?? currentUser?.email ?? 'Unknown'));

                    return Align(
                      alignment: isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 8.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: isCurrentUser
                              ? Colors.blue.shade100
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: isCurrentUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              message['sender'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    isCurrentUser ? Colors.blue : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              message['message'],
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // 배경색을 흰색으로 설정
                    side: BorderSide(
                        color: Colors.black), // 버튼 테두리를 검정색으로 설정 (선택사항)
                  ),
                  child: const Text(
                    '전송',
                    style: TextStyle(
                      color: Colors.black, // 텍스트 색을 검정색으로 설정 (흰색 배경에 잘 보이게)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
