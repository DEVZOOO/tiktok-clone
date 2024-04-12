import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';
import 'package:tiktok_clone/features/inbox/repos/message_repo.dart';

class MessagesViewModel extends AsyncNotifier<void> {
  late final MessageRepository _repo;

  @override
  FutureOr<void> build() {
    _repo = ref.read(messageRepo);
  }

  /// 메세지 전송
  Future<void> sendMessages(String text) async {
    state = const AsyncValue.loading();

    final user = ref.read(authRepo).user;

    state = await AsyncValue.guard(() async {
      final message = MessageModel(
        text: text,
        userId: user!.uid,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      _repo.sendMessage(message);
    });
  }
}

final messageProvider = AsyncNotifierProvider<MessagesViewModel, void>(
  () => MessagesViewModel(),
);

final chatProvider = StreamProvider.autoDispose
    .family<List<MessageModel>, String>((ref, chatRoomId) {
  // <List<MessageModel>>((ref) {
  // firestore 접근
  final db = FirebaseFirestore.instance;
  return db
      .collection("chat_rooms")
      .doc(chatRoomId)
      .collection("texts")
      .orderBy("createdAt")
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (e) => MessageModel.fromJson(
                e.data(),
              ),
            )
            .toList()
            .reversed
            .toList(),
      );
});
