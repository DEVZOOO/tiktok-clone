import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

/// Inbox > activity
class ActivityScreen extends StatefulWidget {
  static const String routeUrl = "/activity";
  static const String routeName = "activity";

  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _notifications = List.generate(20, (index) => '${index}h');

  final List<Map<String, dynamic>> _tabs = [
    {
      "title": "All activity",
      "icon": FontAwesomeIcons.solidMessage,
    },
    {
      "title": "Likes",
      "icon": FontAwesomeIcons.solidHeart,
    },
    {
      "title": "Comments",
      "icon": FontAwesomeIcons.solidComments,
    },
    {
      "title": "Mentions",
      "icon": FontAwesomeIcons.at,
    },
    {
      "title": "Followers",
      "icon": FontAwesomeIcons.solidUser,
    },
    {
      "title": "From TikTok",
      "icon": FontAwesomeIcons.tiktok,
    },
  ];

  /// block 영역 show/hide
  bool _showBarrier = false;

  /// animatin controller 생성
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  /// arrow animation 정의 및 controller와 연결
  late final Animation<double> _arrowAnimation = Tween(
    begin: 0.0,
    end: .5,
  ).animate(_animationController);

  /// panel animation 정의 및 controller와 연결
  late final Animation<Offset> _panelAnimation = Tween(
    begin: const Offset(0, -1), // 비율
    end: Offset.zero,
  ).animate(_animationController);

  /// barrier animation 정의 및 controller와 연결
  late final Animation<Color?> _barrierAnimation = ColorTween(
    begin: Colors.transparent,
    end: Colors.black38,
  ).animate(_animationController);

  /// hide panel
  void _onDismissed(String noti) {
    _notifications.remove(noti);
    setState(() {});
  }

  /// title 클릭
  void _toggleAnimation() async {
    // 애니메이션 완료됬다면(forward 했다면) 반대로
    if (_animationController.isCompleted) {
      await _animationController.reverse(); // 애니메이션 끝날때까지 기다리고 setState
    } else {
      _animationController.forward(); // begin > end
    }

    setState(() {
      _showBarrier = !_showBarrier;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _toggleAnimation,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('All activity'),
              Gaps.h2,
              RotationTransition(
                turns: _arrowAnimation,
                child: const FaIcon(
                  FontAwesomeIcons.chevronDown,
                  size: Sizes.size14,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Gaps.v14,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.size12),
                child: Text(
                  'New',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: Sizes.size14,
                  ),
                ),
              ),

              Gaps.v14,

              // 알림 리스트 영역
              for (var noti in _notifications)
                Dismissible(
                  key: Key(noti),
                  onDismissed: (direction) => _onDismissed(noti),
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    child: const Padding(
                      padding: EdgeInsets.only(left: Sizes.size10),
                      child: FaIcon(
                        FontAwesomeIcons.checkDouble,
                        color: Colors.white,
                        size: Sizes.size32,
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: const Padding(
                      padding: EdgeInsets.only(right: Sizes.size10),
                      child: FaIcon(
                        FontAwesomeIcons.trashCan,
                        color: Colors.white,
                        size: Sizes.size32,
                      ),
                    ),
                  ),
                  child: ListTile(
                    // contentPadding: EdgeInsets.zero, // 패딩 삭제
                    minVerticalPadding: Sizes.size16,
                    leading: Container(
                      width: Sizes.size52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? Colors.grey.shade800 : Colors.white,
                        border: Border.all(
                          color: isDark
                              ? Colors.grey.shade800
                              : Colors.grey.shade400,
                          width: Sizes.size1,
                        ),
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.bell,
                        ),
                      ),
                    ),

                    title: RichText(
                      text: TextSpan(
                        text: 'Account updates',
                        style: TextStyle(
                          color: isDark ? null : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: Sizes.size16,
                        ),
                        children: [
                          const TextSpan(
                            text: ': Upload longer videos',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          TextSpan(
                            text: ' $noti',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    trailing: const FaIcon(
                      FontAwesomeIcons.chevronRight,
                      size: Sizes.size16,
                    ),
                  ),
                ),
            ],
          ),

          // block
          if (_showBarrier)
            AnimatedModalBarrier(
              color: _barrierAnimation,
              dismissible: true, // 영역 클릭
              onDismiss: _toggleAnimation, // 영역 클릭 핸들러
            ),

          // top panel
          SlideTransition(
            position: _panelAnimation,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(Sizes.size5),
                  bottomRight: Radius.circular(Sizes.size5),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var tab in _tabs)
                    ListTile(
                      title: Row(
                        children: [
                          Icon(
                            tab['icon'],
                            size: Sizes.size16,
                          ),
                          Gaps.h20,
                          Text(
                            tab['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
