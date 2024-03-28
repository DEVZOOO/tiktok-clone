import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  List<VideoModel> _list = [
    VideoModel(title: "First Video"),
  ];

  void uploadVideo() async {
    state = const AsyncValue.loading(); // 강제 로딩상태로 변함

    await Future.delayed(const Duration(seconds: 2));

    final newVideo = VideoModel(title: "${DateTime.now()}");
    _list = [
      ..._list,
      newVideo,
    ];

    state = AsyncValue.data(_list); // AsyncNotifier라서 asyncvalue로 해야함
  }

  /// future or model
  @override
  FutureOr<List<VideoModel>> build() async {
    await Future.delayed(const Duration(seconds: 5));

    // throw Exception("omg cant fetch!");
    return _list;
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
