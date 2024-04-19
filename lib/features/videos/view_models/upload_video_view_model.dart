import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';
import 'package:tiktok_clone/utils.dart';

class UploadVideoViewModel extends AsyncNotifier<void> {
  late final VideosRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(videosRepo);
  }

  /// 비디오 업로드
  Future<void> uploadVideo(
      File video, String title, String desc, BuildContext context) async {
    final user = ref.read(authRepo).user;
    final userProfile = ref.read(usersProvider).value;
    if (userProfile != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        // upload to storage
        final task = await _repository.uploadVideoFile(
          video,
          user!.uid,
        );

        // 성공
        if (task.metadata != null) {
          // create document in database
          await _repository.saveVideo(VideoModel(
            id: "",
            title: title,
            description: desc,
            fileUrl: await task.ref.getDownloadURL(),
            thumbnailUrl: "",
            likes: 0,
            comments: 0,
            creatorUid: user.uid,
            creator: userProfile.name,
            createdAt: DateTime.now().millisecondsSinceEpoch,
          ));

          // context.pushReplacement("/home");
          context.pop(); // camera
          context.pop(); // tab
        }
      });

      if (state.hasError) {
        if (kDebugMode) {
          print(state.error.toString());
        }
        showFirebaseErrorSnack(context, state.error);
      }
    }
  }
}

final uploadVideoProvider = AsyncNotifierProvider<UploadVideoViewModel, void>(
  () => UploadVideoViewModel(),
);
