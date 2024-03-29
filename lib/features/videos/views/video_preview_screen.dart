import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:tiktok_clone/features/videos/view_models/timeline_view_model.dart';
import 'package:video_player/video_player.dart';

/// 비디오 녹화 후 미리보기 화면
class VideoPreviewScreen extends ConsumerStatefulWidget {
  /// preview할 비디오
  final XFile video;

  /// 갤러리에서 선택했는지
  final bool isPicked;

  const VideoPreviewScreen({
    super.key,
    required this.video,
    required this.isPicked,
  });

  @override
  VideoPreviewScreenState createState() => VideoPreviewScreenState();
}

class VideoPreviewScreenState extends ConsumerState<VideoPreviewScreen> {
  late final VideoPlayerController _videoPlayerController;
  bool _savedVideo = false;

  @override
  void initState() {
    super.initState();

    _initVideo();
  }

  Future<void> _initVideo() async {
    _videoPlayerController =
        VideoPlayerController.file(File(widget.video.path));

    await _videoPlayerController.initialize(); // 초기화

    await _videoPlayerController.setLooping(true); // 반복재생여부

    await _videoPlayerController.play(); // 재생

    setState(() {});
  }

  /// 갤러리 저장
  Future<void> _saveToGallery() async {
    // 이미 저장했으면 리턴
    if (_savedVideo) {
      return;
    }

    // 저장
    await GallerySaver.saveVideo(
      widget.video.path,
      albumName: "TikTok Clone",
    );

    _savedVideo = true;
    setState(() {});
  }

  void _onUploadPressed() {
    ref.read(timelineProvider.notifier).uploadVideo();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Preview Video"),
        actions: [
          if (!widget.isPicked)
            IconButton(
              onPressed: _saveToGallery,
              icon: FaIcon(
                _savedVideo
                    ? FontAwesomeIcons.check
                    : FontAwesomeIcons.download,
              ),
            ),
          IconButton(
            onPressed: ref.watch(timelineProvider).isLoading
                ? () {}
                : _onUploadPressed,
            icon: ref.watch(timelineProvider).isLoading
                ? const CircularProgressIndicator()
                : const FaIcon(FontAwesomeIcons.cloudArrowUp),
          ),
        ],
      ),
      body: _videoPlayerController.value.isInitialized
          ? VideoPlayer(_videoPlayerController)
          : null,
    );
  }
}
