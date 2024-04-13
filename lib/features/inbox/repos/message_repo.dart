import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';

class MessageRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 채팅방 리스트 조회
  Future<QuerySnapshot<Map<String, dynamic>>> fetchChatRooms(String uid) {
    return _db
        .collection("chat_rooms")
        .where(
          Filter.or(
            Filter("personA", isEqualTo: uid),
            Filter("personB", isEqualTo: uid),
          ),
        )
        .get();
  }

  /// 신규 채팅방 생성
  /// [uid] 로그인한 유저 아이디
  /// [targetUid] 채팅 요청할 유저 아이디
  Future<void> createNewChat(ChatRoomModel chat) async {
    // chat_rooms 생성
    await _db.collection("chat_rooms").doc().set(chat.toJson());
  }

  /// 메세지 전송
  Future<void> sendMessage(MessageModel msg, String roomId) async {
    await _db.collection("chat_rooms").doc(roomId).collection("texts").add(
          msg.toJson(),
        );
  }
}

final messageRepo = Provider((ref) => MessageRepository());
