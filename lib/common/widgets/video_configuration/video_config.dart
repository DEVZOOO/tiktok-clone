import 'package:flutter/material.dart';

// Provider
class VideoConfig extends ChangeNotifier {
  bool isMuted = false;
  bool isAutoplay = false;

  void toggleIsMuted() {
    isMuted = !isMuted;
    notifyListeners();
  }

  void toggleAutoplay() {
    isAutoplay = !isAutoplay;
    notifyListeners();
  }
}

// ValueNotifier
// final videoConfig = ValueNotifier(false);

// ChangeNotifier
/*
class VideoConfig extends ChangeNotifier {
  bool autoMute = false; // 데이터

  /// 데이터 변경
  void toggleAutoMute() {
    autoMute = !autoMute;
    notifyListeners(); // 데이터 변경사항을 듣고 있는 위젯들에 알려줌
  }
}

final videoConfig = VideoConfig();  // 전역변수
*/



// InheritedWidget + StatefulWidget
/*
/// 모든 위젯트리에서 접근 가능한 데이터
class VideoConfigData extends InheritedWidget {
  final bool autoMute;
  final void Function() toggleMuted;

  const VideoConfigData({
    super.key,
    required super.child,
    required this.autoMute,
    required this.toggleMuted,
  }); // child 필요

  /// of 생성자
  static VideoConfigData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<VideoConfigData>()!;

  /// 업데이트시 rebuild 여부
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // 리랜더링하면 old widget을 가질수 있고 상속하는 위젯 리빌드 여부 결정
    return true;
  }
}

/// 데이터와 업데이트 메소드는 stf 이 가지고 있음
class VideoConfig extends StatefulWidget {
  final Widget child;

  const VideoConfig({
    super.key,
    required this.child,
  });

  @override
  State<VideoConfig> createState() => _VideoConfigState();
}

class _VideoConfigState extends State<VideoConfig> {
  bool autoMute = false;

  /// 상태값 변경
  void _toggleMuted() {
    setState(() {
      autoMute = !autoMute;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VideoConfigData(
      autoMute: autoMute,
      toggleMuted: _toggleMuted,
      child: widget.child,
    );
  }
}
*/
