import 'package:flutter/material.dart';
import 'package:tiktok_clone/features/videos/widgets/video_post.dart';

/// 영상 목록(Home) 화면
class VideoTimelineScreen extends StatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  State<VideoTimelineScreen> createState() => _VideoTimelineScreenState();
}

class _VideoTimelineScreenState extends State<VideoTimelineScreen> {
  int _itemCount = 4;

  final PageController _pageController = PageController();

  final _scrollDuration = const Duration(milliseconds: 250);
  final _scrollCurve = Curves.linear;

  /// 페이지 변경 이벤트
  void _onPageChange(int page) {
    _pageController.animateToPage(
      page,
      duration: _scrollDuration,
      curve: _scrollCurve,
    );

    if (page == _itemCount - 1) {
      // 페이지 추가 - 무한스크롤링
      _itemCount += 4;
      setState(() {});
    }
  }

  /// 영상 끝날대 콜백
  void _onVideoFinished() {
    return;

    // nextPage 호출해주면 현재 어느 페이지에 있는지 알 필요 없이 다음 페이지로 넘어가게 해줌
    _pageController.nextPage(
      duration: _scrollDuration,
      curve: _scrollCurve,
    );
  }

  Future<void> _onRefresh() {
    return Future.delayed(const Duration(seconds: 5));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      // async of Future
      onRefresh: _onRefresh,
      displacement: 50, // indicator 위치 설정
      edgeOffset: 30, // indicator 시작 위치
      // color: Colors.white, // 선 색상
      color: Theme.of(context).primaryColor,
      // backgroundColor: Theme.of(context).primaryColor,
      strokeWidth: 4, // 선 굵기
      child: PageView.builder(
        controller: _pageController,
        // dynamic render
        itemCount: _itemCount,
        itemBuilder: (context, index) {
          return VideoPost(
            onVideoFinished: _onVideoFinished,
            index: index,
          );
        },
        // pageSnapping: false, // false : 화면이 사용자가 스크롤한 그 위치에 멈춤
        scrollDirection: Axis.vertical,
        onPageChanged: _onPageChange,
      ),
    );
  }
}
