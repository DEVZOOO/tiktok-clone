import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

/// nav bar > 동영상 업로드 버튼(+)
class PostVideoButton extends StatelessWidget {
  const PostVideoButton({
    super.key,
    required this.isLongTab,
    required this.inverted,
  });

  final bool isLongTab;
  final bool inverted;

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return Stack(
      clipBehavior: Clip.none, // 영역 벗어난거 자르지 않음
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 150),
          right: Sizes.size20,
          top: isLongTab ? -5 : 0,
          child: Container(
            height: 30,
            width: 25,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xff61D4F0),
              borderRadius: BorderRadius.circular(Sizes.size8),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 100),
          left: Sizes.size20,
          bottom: isLongTab ? -5 : 0,
          child: Container(
            height: 30,
            width: 25,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size8,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(Sizes.size8),
            ),
          ),
        ),
        Container(
          height: 30,
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size12,
          ),
          decoration: BoxDecoration(
            color: !inverted || isDark ? Colors.white : Colors.black,
            borderRadius: BorderRadius.circular(Sizes.size6),
          ),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.plus,
              color: inverted && !isDark ? Colors.white : Colors.black,
              size: 18,
            ),
          ),
        )
      ],
    );
  }
}
