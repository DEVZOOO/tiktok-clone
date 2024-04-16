import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/repos/message_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repos/user_repository.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/utils.dart';

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

  /// 회원리스트 조회
  Future<List<UserProfileModel>> getAllUsers(String? exceptUid) async {
    final result = await ref.read(userRepo).getAllUsers(exceptUid);
    final users = result.docs.map(
      (e) => UserProfileModel.fromJson(e.data()),
    );
    return users.toList();
  }

  // refresh chatRoomList
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final list = await _fetchChatRooms();
    _rooms = list;
    state = AsyncValue.data(list);
  }

  /// 신규 채팅방 생성
  Future<void> createNewChat(UserProfileModel targetUser) async {
    final user = ref.read(usersProvider).value!;
    final chat = ChatRoomModel(
      id: "",
      personA: user.uid,
      personB: targetUser.uid,
      personAname: user.name,
      personBname: targetUser.name,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _repository.createNewChat(chat);
  }

  /// 채팅방 삭제
  Future<void> deleteChatRoom(String roomId) async {
    state = const AsyncValue.loading();
    await _repository.deleteChatRoom(roomId);
    state = AsyncValue.data(
        state.value!.where((element) => element.id != roomId).toList());
  }
}

final chatRoomProvider =
    AsyncNotifierProvider<ChatRoomViewModel, List<ChatRoomModel>>(
        () => ChatRoomViewModel());
