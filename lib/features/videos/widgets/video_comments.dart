import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils.dart';

class VideoComments extends StatefulWidget {
  const VideoComments({super.key});

  @override
  State<VideoComments> createState() => _VideoCommentsState();
}

class _VideoCommentsState extends State<VideoComments> {
  bool _isWriting = false;
  final ScrollController _scrollController = ScrollController();

  /// 닫기버튼
  void _onClosedPressed() {
    Navigator.of(context).pop();
  }

  /// 텍스트 입력 끝
  void _stopWriting() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isWriting = false;
    });
  }

  /// 텍스트영역 클릭
  void _onStartWriting() {
    setState(() {
      _isWriting = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = isDarkMode(context);

    return Container(
      clipBehavior: Clip.hardEdge,
      height: size.height * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.size14),
      ),
      child: Scaffold(
        backgroundColor: isDark ? null : Colors.grey.shade50,
        appBar: AppBar(
          title: Text(S.of(context).commentTitle(0, 0)),
          automaticallyImplyLeading: false, // 버튼 삭제
          backgroundColor: isDark ? null : Colors.grey.shade50,
          actions: [
            // app bar에 동작 버튼 추가
            IconButton(
              onPressed: _onClosedPressed,
              icon: const FaIcon(FontAwesomeIcons.xmark),
            ),
          ],
        ),
        body: GestureDetector(
          onTap: _stopWriting, // 영역 클릭시 iput unfocus
          child: Stack(
            children: [
              Scrollbar(
                controller: _scrollController,
                child: ListView.separated(
                  controller: _scrollController,
                  separatorBuilder: (context, index) => Gaps.v20,
                  padding: const EdgeInsets.only(
                    top: Sizes.size10,
                    left: Sizes.size16,
                    right: Sizes.size16,
                    bottom: Sizes.size96 + Sizes.size10,
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 프로필사진
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: isDark ? Colors.grey.shade500 : null,
                          child: const Text('Judy'),
                        ),

                        Gaps.h10,

                        // 내용
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Judy',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Sizes.size14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              Gaps.v4,
                              const Text(
                                  "That's not it I've seen the same thing but also in a cave."),
                            ],
                          ),
                        ),

                        Gaps.h10,

                        // 좋아요
                        Column(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.heart,
                              size: Sizes.size20,
                              color: Colors.grey.shade500,
                            ),
                            Gaps.v4,
                            Text(
                              '52.2K',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),

              // 댓글입력영역
              Positioned(
                bottom: 0,
                width: size.width,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.size16,
                      vertical: Sizes.size10,
                    ),
                    child: Row(
                      children: [
                        // 프로필사진
                        CircleAvatar(
                          radius: 18,
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.grey.shade500,
                          child: const Text('Judy'),
                        ),

                        Gaps.h10,

                        // 댓글입력창
                        Expanded(
                          child: SizedBox(
                            height: Sizes.size44,
                            child: TextField(
                              onTap: _onStartWriting,
                              expands: true, // 늘어난다
                              minLines: null, // 최소줄수
                              maxLines: null, // 최대줄수, 입력만큼 늘어남
                              textInputAction:
                                  TextInputAction.newline, // 엔터버튼 커스텀
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                  hintText: 'Write a comment...',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(Sizes.size12),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor:
                                      isDark ? null : Colors.grey.shade200,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: Sizes.size12,
                                  ),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                        right: Sizes.size14),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.at,
                                          color: isDark
                                              ? null
                                              : Colors.grey.shade900,
                                        ),
                                        Gaps.h14,
                                        FaIcon(
                                          FontAwesomeIcons.gift,
                                          color: isDark
                                              ? null
                                              : Colors.grey.shade900,
                                        ),
                                        Gaps.h14,
                                        FaIcon(
                                          FontAwesomeIcons.faceSmile,
                                          color: isDark
                                              ? null
                                              : Colors.grey.shade900,
                                        ),
                                        Gaps.h14,

                                        // 전송
                                        if (_isWriting)
                                          GestureDetector(
                                            onTap: _stopWriting,
                                            child: FaIcon(
                                              FontAwesomeIcons.circleArrowUp,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                      ],
                                    ),
                                  )),
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
      ),
    );
  }
}
