import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class VideoPostViewModel extends FamilyAsyncNotifier<void, String> {
  late final VideosRepository _repository;
  late final String _videoId;

  @override
  FutureOr<void> build(String videoId) async {
    _repository = ref.read(videosRepo);
    _videoId = videoId;
  }

  Future<bool> isLiked() async {
    final uid = ref.read(authRepo).user!.uid;
    final like = await _repository.isLiked(_videoId, uid);
    return like;
  }

  /// 좋아요
  Future<void> toggleLikeVideo() async {
    final user = ref.read(authRepo).user;
    await _repository.toggleLikeVideo(_videoId, user!.uid);
  }
}

final videoPostProvider =
    AsyncNotifierProvider.family<VideoPostViewModel, void, String>(
  () => VideoPostViewModel(),
);
