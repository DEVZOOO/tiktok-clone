import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/repos/message_repo.dart';

class ChatRoomViewModel extends AsyncNotifier<List<ChatRoomModel>> {
  late final MessageRepository _repository;
  List<ChatRoomModel> _rooms = [];

  /// 채팅방 리스트 조회
  Future<List<ChatRoomModel>> _fetchChatRooms() async {
    state = const AsyncValue.loading();

    final user = ref.read(authRepo).user;
    final result = await _repository.fetchChatRooms(user!.uid);
    final rooms = result.docs.map(
      (e) {
        print(e.data());
        return ChatRoomModel.fromJson(
          e.data(),
          e.id,
        );
      },
    );

    return rooms.toList();
  }

  @override
  FutureOr<List<ChatRoomModel>> build() async {
    _repository = ref.read(messageRepo);
    _rooms = await _fetchChatRooms();
    return _rooms;
  }

  /// 신규 채팅방 생성
  Future<void> createNewChat(String targetUid) async {
    final user = ref.read(authRepo).user!;
    final chat = ChatRoomModel(
      id: "",
      personA: user.uid,
      personB: targetUid,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _repository.createNewChat(chat);
  }
}

final chatRoomProvider =
    AsyncNotifierProvider<ChatRoomViewModel, List<ChatRoomModel>>(
        () => ChatRoomViewModel());
