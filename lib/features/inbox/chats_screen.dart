import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/view_models/chat_room_view_model.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/utils.dart';

/// DM
class ChatsScreen extends ConsumerStatefulWidget {
  static const String routeUrl = "/chats";
  static const String routeName = "chats";

  const ChatsScreen({super.key});

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  final Duration _duration = const Duration(milliseconds: 300);

  /// 신규 채팅 유저
  UserProfileModel? _newChatUser;

  /// 리스트 아이템 추가
  void _addItem() async {
    /*
    if (_key.currentState != null) {
      
      // 아이템 추가, index : 위치
      _key.currentState!.insertItem(
        _items.length,
        duration: _duration,
      );
      _items.add(_items.length);
    }
    */

    if (kDebugMode) {
      print("_addItem");
    }

    final uid = ref.read(authRepo).user!.uid;
    final users = await ref.read(chatRoomProvider.notifier).getAllUsers(uid);

    if (!mounted) {
      return;
    }

    // 유저 선택 후 채팅방 추가
    _newChatUser = null;
    final result = await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => AlertDialog(
            actions: [
              const CloseButton(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, "OK");
                },
                child: const Text("OK"),
              ),
            ],
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return RadioListTile(
                    groupValue: _newChatUser?.uid,
                    value: user.uid,
                    onChanged: (String? value) {
                      setState(() {
                        _newChatUser = user;
                      });
                    },
                    title: Text(user.name),
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    if (result != null) {
      if (_newChatUser != null) {
        ref.read(chatRoomProvider.notifier).createNewChat(_newChatUser!);
      }
    }
  }

  /// 리스트 아이템 삭제
  void _deleteItem(int index, ChatRoomModel chat) {
    if (_key.currentState != null) {
      _key.currentState!.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: Container(
            color: Colors.red,
            child: _makeTile(index, chat),
          ),
        ),
        duration: _duration,
      );

      // DB 삭제
      ref.read(chatRoomProvider.notifier).deleteChatRoom(chat.id);
    }
  }

  /// 채팅 입장
  void _onChatTap({
    required String roomId,
    required String uid,
    required String name,
  }) {
    /*
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatDetailScreen(),
      ),
    );
    */

    context.pushNamed(
      ChatDetailScreen.routeName,
      params: {
        "chatId": roomId,
      },
      extra: {
        "uid": uid,
        "name": name,
      },
    );
  }

  /// tile 생성 메소드
  Widget _makeTile(int index, ChatRoomModel chat) {
    final user = ref.read(authRepo).user!;
    final uid = chat.personA == user.uid ? chat.personB : chat.personA;
    final name = chat.personA == user.uid ? chat.personBname : chat.personAname;
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(getProfileImageUrl(uid)),
        child: Text(name),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '2:16PM',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: Sizes.size12,
            ),
          ),
        ],
      ),
      subtitle: const Text('Don\'t forget to make video.'),
      onTap: () => _onChatTap(roomId: chat.id, uid: uid, name: name),
      onLongPress: () => _deleteItem(index, chat),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direct Messages'),
        elevation: 1,
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const FaIcon(FontAwesomeIcons.plus),
          ),
        ],
      ),
      body: ref.watch(chatRoomProvider).when(
            data: (data) {
              return RefreshIndicator(
                color: Theme.of(context).primaryColor,
                child: data.isNotEmpty
                    ? AnimatedList(
                        key: _key,
                        padding:
                            const EdgeInsets.symmetric(vertical: Sizes.size10),
                        initialItemCount: data.length,
                        itemBuilder: (context, index, animation) {
                          final chat = data[index];
                          return FadeTransition(
                            key: UniqueKey(),
                            opacity: animation,
                            child: SizeTransition(
                              sizeFactor: animation,
                              child: _makeTile(index, chat),
                            ),
                          );
                        },
                      )
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .7,
                          child: const Center(child: Text("Start New Chat!")),
                        ),
                      ),
                onRefresh: () async {
                  return ref.watch(chatRoomProvider.notifier).refresh();
                },
              );
            },
            error: (error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
