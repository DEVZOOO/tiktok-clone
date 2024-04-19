import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  late final VideosRepository _repository;
  List<VideoModel> _list = [
    // VideoModel(title: "First Video"),
  ];

  /// firebase에서 비디오 가져오기
  Future<List<VideoModel>> _fetchVideos({
    int? lastItemCreatedAt,
  }) async {
    final result =
        await _repository.fetchVideos(lastItemCreatedAt: lastItemCreatedAt);
    final videos = result.docs.map(
      (doc) => VideoModel.fromJson(
        json: doc.data(),
        videoId: doc.id,
      ),
    );
    return videos.toList();
  }

  /*
  void uploadVideo() async {
    state = const AsyncValue.loading(); // 강제 로딩상태로 변함

    await Future.delayed(const Duration(seconds: 2));

    // final newVideo = VideoModel(title: "${DateTime.now()}");
    _list = [
      ..._list,
      // newVideo,
    ];

    state = AsyncValue.data(_list); // AsyncNotifier라서 asyncvalue로 해야함
  }
  */

  /// future or model
  @override
  FutureOr<List<VideoModel>> build() async {
    _repository = ref.read(videosRepo);
    _list = await _fetchVideos(lastItemCreatedAt: null);
    // await Future.delayed(const Duration(seconds: 5));
    // throw Exception("omg cant fetch!");
    return _list;
  }

  /// 다음 페이지 조회 - 스크롤링
  Future<void> fetchNextPage() async {
    final nextPage =
        await _fetchVideos(lastItemCreatedAt: _list.last.createdAt);
    state = AsyncValue.data([
      // 기존 값에 추가
      ..._list,
      ...nextPage,
    ]);
  }

  /// 새로고침
  Future<void> refresh() async {
    final videos = await _fetchVideos(lastItemCreatedAt: null);
    _list = videos;
    state = AsyncValue.data(videos); // 완전히 새로운 값으로 변경
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
