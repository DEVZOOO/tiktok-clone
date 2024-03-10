import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

/// tutorial - 1 화면
class Tutorial1Screen extends StatelessWidget {
  const Tutorial1Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gaps.v80,
        FractionallySizedBox(
          widthFactor: 1,
          child: Text(
            'Watch cool videos!',
            style: TextStyle(
              fontSize: Sizes.size40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Gaps.v16,
        Text(
          'Videos are personalized for you based on what you watch, like, and share',
          style: TextStyle(
            fontSize: Sizes.size20,
          ),
        ),
      ],
    );
  }
}
