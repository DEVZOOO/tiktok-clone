import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/view_models/messages_view_model.dart';
import 'package:tiktok_clone/utils.dart';

/// 대화창
class ChatDetailScreen extends ConsumerStatefulWidget {
  static const String routeUrl = ":chatId";
  static const String routeName = "chartDetail";

  final String chatId;
  final String uid;
  final String userName;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.uid,
    required this.userName,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _isWriting = false;

  /// unfocus
  void _unfocusAll() {
    FocusScope.of(context).unfocus();
  }

  /// textfield 변경
  void _onTextChanged() {
    if (_textEditingController.text.isEmpty) {
      _isWriting = false;
    } else {
      _isWriting = true;
    }

    setState(() {});
  }

  /// 메세지 전송 버튼 탭
  void _onSendTap() {
    // 작성중이 아니라면 리턴
    if (!_isWriting) {
      return;
    }

    final text = _textEditingController.text;
    if (text != "") {
      ref.read(messageProvider(widget.chatId).notifier).sendMessages(text);
    }

    _textEditingController.clear(); // 입력값 삭제

    setState(() {
      _isWriting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(messageProvider(widget.chatId)).isLoading;
    final isDark = isDarkMode(context);
    return GestureDetector(
      onTap: _unfocusAll,
      child: Scaffold(
        appBar: AppBar(
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: Sizes.size8,

            // ## Challenge 1
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: Sizes.size24,
                  foregroundImage: NetworkImage(getProfileImageUrl(widget.uid)),
                  child: Text(
                    widget.userName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0, // border width 만큼 아래로 이동
                  child: Container(
                    width: Sizes.size16,
                    height: Sizes.size16,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      border: Border.all(
                        color: Colors.white,
                        width: Sizes.size2,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                    ),
                  ),
                ),
              ],
            ),
            title: Text(
              widget.userName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: const Text('Active now'),
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.flag,
                  size: Sizes.size20,
                ),
                Gaps.h32,
                FaIcon(
                  FontAwesomeIcons.ellipsis,
                  size: Sizes.size20,
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            ref.watch(chatProvider(widget.chatId)).when(
                  data: (data) {
                    return ListView.separated(
                      reverse: true, // 아래에서부터 보여지기
                      padding: EdgeInsets.only(
                        top: Sizes.size20,
                        bottom: MediaQuery.of(context).padding.bottom +
                            Sizes.size96,
                        left: Sizes.size14,
                        right: Sizes.size14,
                      ),
                      separatorBuilder: (context, index) => Gaps.v10,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final msg = data[index];
                        final isMine =
                            msg.userId == ref.watch(authRepo).user!.uid;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: isMine
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(Sizes.size14),
                              decoration: BoxDecoration(
                                color: isMine
                                    ? Colors.blue
                                    : Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(Sizes.size20),
                                  topRight: const Radius.circular(Sizes.size20),
                                  bottomLeft: Radius.circular(
                                      isMine ? Sizes.size20 : Sizes.size5),
                                  bottomRight: Radius.circular(
                                      isMine ? Sizes.size5 : Sizes.size20),
                                ),
                              ),
                              child: Text(
                                msg.text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: Sizes.size16,
                                ),
                              ),
                            ),
                          ],
                        );
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

            // ## challenge 2
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: BottomAppBar(
                color: isDark ? null : Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.size10,
                    horizontal: Sizes.size14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: Sizes.size40,
                          child: TextField(
                            controller: _textEditingController,
                            onChanged: (value) => _onTextChanged(),
                            textInputAction: TextInputAction.newline,
                            expands: true,
                            minLines: null,
                            maxLines: null,
                            enableSuggestions: false, // 자동완성 비허용
                            style: const TextStyle(
                              // color: Colors.black,
                              fontSize: Sizes.size16,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Send a message ...',
                              fillColor: isDark ? null : Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              ),
                              // smile icon
                              suffixIcon: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.faceSmile,
                                    size: Sizes.size20,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ],
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.size12),
                            ),
                          ),
                        ),
                      ),
                      Gaps.h10,
                      // send icon
                      GestureDetector(
                        onTap: isLoading ? null : _onSendTap, // 로딩중에 실행하지 않음
                        child: Container(
                          padding: const EdgeInsets.all(Sizes.size8),
                          decoration: BoxDecoration(
                            color: _isWriting
                                ? Theme.of(context).primaryColor
                                : null, // Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: FaIcon(
                            isLoading
                                ? FontAwesomeIcons.hourglass
                                : FontAwesomeIcons.solidPaperPlane,
                            size: Sizes.size18,
                            color: isDark && !_isWriting
                                ? Colors.grey.shade700
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
