import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/widgets/video_comments.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// 영상 위젯
class VideoPost extends StatefulWidget {
  final Function onVideoFinished;
  final int index;

  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.index,
  });

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset('assets/videos/video.mp4'); // 리소스 경로

  late AnimationController _animationController;

  bool _isPaused = false;
  final Duration _animationDuration = const Duration(milliseconds: 200);

  // 영상 정보 펼치기 여부
  bool _seeAll = false;

  /// 영상 변경 이벤트
  void _onVideoChange() {
    // 초기화 여부
    if (_videoPlayerController.value.isInitialized) {
      // 영상 길이 == 현재 재생 영상 위치
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  /// 비디오플레이어 위젯 관련 초기화
  void _initVideoPlayer() async {
    // controller 초기화
    await _videoPlayerController.initialize();

    // 재생
    // _videoPlayerController.play();

    // 반복재생
    await _videoPlayerController.setLooping(true);

    // 상태 업데이트
    setState(() {});

    // 이벤트리스너 등록
    _videoPlayerController.addListener(_onVideoChange);
  }

  /// 화면에 표시되는 정도 변경 이벤트
  void _onVisibilityChange(VisibilityInfo info) {
    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }

    // 영상이 재생되고 있는데 전혀 보이지 않으면(화면에서 보이지 않으면)
    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      _onTogglePause();
    }
  }

  /// 영상 위의 GestureDetector 탭 이벤트
  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse(); // value change upperBound > lowerBound
    } else {
      _videoPlayerController.play();
      _animationController.forward(); // value change lowerBound > upperBound
    }

    setState(() {
      _isPaused = !_isPaused;
    });
  }

  /// see all 클릭
  void _onToggleSeeAll() {
    print('seee more');
    setState(() {
      _seeAll = !_seeAll;
    });
  }

  /// 댓글 버튼 클릭
  void _onCommentsTap(BuildContext context) async {
    // 영상 일시정지
    if (_videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }

    // 댓글창 오픈
    // bottom sheet 닫히면 resolve됨!
    // bottom sheet 닫힐때까지 await
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const VideoComments();
      },
      backgroundColor: Colors.transparent,
    );

    // bottom sheet 닫힘
    _onTogglePause();
  }

  @override
  void initState() {
    super.initState();

    _initVideoPlayer();

    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0, // min value
      upperBound: 1.5, // max value, scale
      value: 1.5, // default, 설정하지 않으면 lowerBound에서 시작함
      duration: _animationDuration,
    );

    // 1
    /*
    // 애니메이션값 변경할때 호출
    _animationController.addListener(() {
      setState(() {}); // build 호출, to call build method
    });
    */
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('${widget.index}'),
      onVisibilityChanged: _onVisibilityChange,
      child: Stack(
        children: [
          // 영상
          Positioned.fill(
            // 화면 전체 채우기
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Container(color: Colors.black),
          ),

          // 클릭
          Positioned.fill(
            child: GestureDetector(
              onTap: _onTogglePause,
            ),
          ),

          // 재생/일시정지 아이콘
          Positioned.fill(
            child: IgnorePointer(
              // 이벤트 무시, 상위에 전달
              child: Center(
                /*
                child: Transform.scale(
                  scale: _animationController.value,
                  child: AnimatedOpacity(
                    opacity: _isPaused ? 1 : 0,
                    duration: _animationDuration,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size52,
                    ),
                  ),
                ),
                */
                child: AnimatedBuilder(
                  animation: _animationController,
                  // animationController value가 변하는걸 감지하고 변경될 때마다 실행됨
                  // @param child : AnimatedBuilder 의 child 넘겨줌
                  builder: (context, child) {
                    // 애니메이션 자체
                    return Transform.scale(
                      scale: _animationController.value, // 항상 최신값 사용함
                      child: child,
                    );
                  },
                  // 애니메이션하고 싶은 것
                  child: AnimatedOpacity(
                    opacity: _isPaused ? 1 : 0,
                    duration: _animationDuration,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size52,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 영상정보영역
          Positioned(
            bottom: 20,
            left: 10,
            width: MediaQuery.of(context).size.width - 10 - 40 - 30, // width 설정
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '@judy',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Sizes.size20,
                  ),
                ),
                Gaps.v10,

                // description
                Row(
                  mainAxisSize: MainAxisSize.max, // 영역 최대한 차지
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // description과 see more 사이 공백
                  children: [
                    Expanded(
                      child: Text(
                        'This is my house in Thailand! blah blah blah blah blah blah blah blah blah blah blah blah blah blah !!!!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: Sizes.size16,
                        ),
                        // see all 아니면 ellipsis 처리
                        overflow: _seeAll
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                      ),
                    ),
                    // see All 선택하지 않은 경우만 추가
                    if (!_seeAll)
                      GestureDetector(
                        onTap: _onToggleSeeAll,
                        child: const Text(
                          'See more',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // 버튼영역
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 25, // 이미지 안올대 대체요소
                  backgroundColor: Colors.black, // 얼마나 클지
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                      'https://avatars.githubusercontent.com/u/104175767?v=4'),
                  child: Text('judy'),
                ),
                Gaps.v24,
                const VideoButton(
                  icon: FontAwesomeIcons.solidHeart,
                  text: '2.9M',
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: () => _onCommentsTap(context),
                  child: const VideoButton(
                    icon: FontAwesomeIcons.solidComment,
                    text: '33.0K',
                  ),
                ),
                Gaps.v24,
                const VideoButton(
                  icon: FontAwesomeIcons.share,
                  text: 'Share',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
