import 'package:flutter/material.dart';

/// 영상 목록(Home) 화면
class VideoTimelineScreen extends StatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  State<VideoTimelineScreen> createState() => _VideoTimelineScreenState();
}

class _VideoTimelineScreenState extends State<VideoTimelineScreen> {
  int _itemCount = 4;

  List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.teal,
  ];

  final PageController _pageController = PageController();

  /// 페이지 변경 이벤트
  void _onPageChange(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );

    if (page == _itemCount - 1) {
      // 페이지 추가 - 무한스크롤링
      _itemCount += 4;
      colors.addAll([
        // 파라미터 리스트를 맨뒤에 모두 추가함
        Colors.blue,
        Colors.red,
        Colors.yellow,
        Colors.teal,
      ]);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      // dynamic render
      itemCount: _itemCount,
      itemBuilder: (context, index) {
        return Container(
          color: colors[index],
          child: Center(
            child: Text(
              'Screen $index',
              style: const TextStyle(
                fontSize: 68,
              ),
            ),
          ),
        );
      },
      // pageSnapping: false, // false : 화면이 사용자가 스크롤한 그 위치에 멈춤
      scrollDirection: Axis.vertical,
      onPageChanged: _onPageChange,
    );
  }
}
