import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/chat_detail_screen.dart';

/// DM
class ChatsScreen extends StatefulWidget {
  static const String routeUrl = "/chats";
  static const String routeName = "chats";

  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  final List<int> _items = [];

  final Duration _duration = const Duration(milliseconds: 300);

  /// 리스트 아이템 추가
  void _addItem() {
    if (_key.currentState != null) {
      // 아이템 추가, index : 위치
      _key.currentState!.insertItem(
        _items.length,
        duration: _duration,
      );
      _items.add(_items.length);
    }
  }

  /// 리스트 아이템 삭제
  void _deleteItem(int index) {
    if (_key.currentState != null) {
      _key.currentState!.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: Container(
            color: Colors.red,
            child: _makeTile(index),
          ),
        ),
        duration: _duration,
      );

      _items.removeAt(index);
    }
  }

  /// 채팅 입장
  void _onChatTap(int index) {
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
        "chatId": "$index",
      },
    );
  }

  /// tile 생성 메소드
  Widget _makeTile(int index) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
            'https://avatars.githubusercontent.com/u/104175767?v=4'),
        child: Text('Judy'),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Lynn - $index',
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
      onTap: () => _onChatTap(index),
      onLongPress: () => _deleteItem(index),
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
      body: AnimatedList(
        key: _key,
        padding: const EdgeInsets.symmetric(vertical: Sizes.size10),
        itemBuilder: (context, index, animation) {
          return FadeTransition(
            key: UniqueKey(),
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              child: _makeTile(index),
            ),
          );
        },
      ),
    );
  }
}
