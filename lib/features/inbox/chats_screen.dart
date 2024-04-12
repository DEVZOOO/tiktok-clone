import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/view_models/chat_room_view_model.dart';

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

  /// 리스트 아이템 추가
  void _addItem() {
    if (_key.currentState != null) {
      /*
      // 아이템 추가, index : 위치
      _key.currentState!.insertItem(
        _items.length,
        duration: _duration,
      );
      _items.add(_items.length);
      */
      // TODO - 유저 선택 후 채팅방 추가
      // ref.read(chatRoomProvider.notifier).createNewChat(uid);
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
    }
  }

  /// 채팅 입장
  void _onChatTap(String id, String userName) {
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
        "chatId": id,
        "userName": userName,
      },
    );
  }

  /// tile 생성 메소드
  Widget _makeTile(int index, ChatRoomModel chat) {
    final user = ref.read(authRepo).user!;
    final name = chat.personA == user.uid ? chat.personB : chat.personB;
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
          'https://firebasestorage.googleapis.com/v0/b/judy-tiktok-clone.appspot.com/o/avatars%2F$name?alt=media&token=029a2805-8f99-445e-ae0d-c93c02ad9ab5',
        ),
        child: Text(name),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            name,
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
      onTap: () => _onChatTap(chat.id, name),
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
              return data.isNotEmpty
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
                  : const Center(
                      child: Text("Start New Chat!"),
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
