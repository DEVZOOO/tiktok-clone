import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

/// tutorial - 2 화면
class Tutorial2Screen extends StatelessWidget {
  const Tutorial2Screen({
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
            'Follow the rules',
            style: TextStyle(
              fontSize: Sizes.size40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Gaps.v16,
        Text(
          'Take care of one another! Plis!',
          style: TextStyle(
            fontSize: Sizes.size20,
          ),
        ),
      ],
    );
  }
}
