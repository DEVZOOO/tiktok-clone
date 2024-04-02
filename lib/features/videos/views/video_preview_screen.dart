import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/view_models/upload_video_view_model.dart';
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

  final TextEditingController _titleTextEditingController =
      TextEditingController();
  final TextEditingController _descTextEditingController =
      TextEditingController();

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

  /// 비디오 업로드
  void _onUploadPressed() {
    // ref.read(timelineProvider.notifier).uploadVideo();
    final video = File(widget.video.path); // xfile to file

    final title = _titleTextEditingController.text;
    final desc = _descTextEditingController.text;

    if (kDebugMode) {
      print(video);
      print(title);
      print(desc);
    }

    ref
        .read(uploadVideoProvider.notifier)
        .uploadVideo(video, title, desc, context);
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
            onPressed: ref.watch(uploadVideoProvider).isLoading
                ? () {}
                : _onUploadPressed,
            icon: ref.watch(uploadVideoProvider).isLoading
                ? const CircularProgressIndicator()
                : const FaIcon(FontAwesomeIcons.cloudArrowUp),
          ),
        ],
      ),
      body: _videoPlayerController.value.isInitialized
          ? Column(
              children: [
                Expanded(child: VideoPlayer(_videoPlayerController)),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 160,
                  padding: const EdgeInsets.all(Sizes.size10),
                  child: Form(
                    child: Column(
                      children: [
                        // title
                        SizedBox(
                          height: Sizes.size44,
                          child: TextFormField(
                            controller: _titleTextEditingController,
                            cursorColor: Colors.red,
                            maxLines: 1,
                            decoration: InputDecoration(
                              prefixIcon: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Title",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              hintText: "Write Title",
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: Sizes.size1,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: Sizes.size1,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.size10),
                            ),
                          ),
                        ),

                        Gaps.v10,
                        // description
                        Expanded(
                          child: SizedBox(
                            child: TextFormField(
                              expands: true,
                              minLines: null,
                              maxLines: null,
                              controller: _descTextEditingController,
                              cursorColor: Colors.red,
                              decoration: InputDecoration(
                                prefixIcon: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Desc",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                hintText: "Write Description",
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: Sizes.size1,
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: Sizes.size1,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: Sizes.size10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : null,
    );
  }
}
