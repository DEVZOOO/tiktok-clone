import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

/// home 우측 버튼
class VideoButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isLiked;

  const VideoButton({
    super.key,
    required this.icon,
    required this.text,
    this.isLiked = false,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      children: [
        FaIcon(
          icon,
          color: isLiked ? primaryColor : Colors.white,
          size: Sizes.size40,
        ),
        Gaps.v5,
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
