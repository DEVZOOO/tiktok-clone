import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

/// 대화창
class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
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

    print(_textEditingController.text);
    _textEditingController.clear(); // 입력값 삭제

    setState(() {
      _isWriting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocusAll,
      child: Scaffold(
        appBar: AppBar(
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: Sizes.size8,

            // Challenge 1
            leading: Stack(
              children: [
                const CircleAvatar(
                  radius: Sizes.size24,
                  foregroundImage: NetworkImage(
                      'https://avatars.githubusercontent.com/u/104175767?v=4'),
                  child: Text('Judy'),
                ),
                Positioned(
                  right: 0,
                  bottom: -3, // border width 만큼 아래로 이동
                  child: Container(
                    width: Sizes.size20,
                    height: Sizes.size20,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      border: Border.all(
                        color: Colors.white,
                        width: Sizes.size3,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                    ),
                  ),
                ),
              ],
            ),
            title: const Text(
              'Judy',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text('Active now'),
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.flag,
                  size: Sizes.size20,
                  color: Colors.black,
                ),
                Gaps.h32,
                FaIcon(
                  FontAwesomeIcons.ellipsis,
                  size: Sizes.size20,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.size20,
                horizontal: Sizes.size14,
              ),
              itemBuilder: (context, index) {
                final isMine = index % 2 == 0;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment:
                      isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
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
                      child: const Text(
                        'This is a messag!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Sizes.size16,
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => Gaps.v10,
              itemCount: 10,
            ),

            // challenge 2
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: BottomAppBar(
                color: Colors.grey.shade100,
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
                              color: Colors.black,
                              fontSize: Sizes.size16,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Send a message ...',
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              ),
                              // smile icon
                              suffixIcon: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.faceSmile,
                                    size: Sizes.size20,
                                    color: Colors.black,
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
                        onTap: _onSendTap,
                        child: Container(
                          padding: const EdgeInsets.all(Sizes.size8),
                          decoration: BoxDecoration(
                            color: _isWriting
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.solidPaperPlane,
                            size: Sizes.size18,
                            color: Colors.white,
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
