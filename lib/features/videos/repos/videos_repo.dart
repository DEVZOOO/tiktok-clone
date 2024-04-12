import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

class VideosRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String _makeLikesDocName(String videoId, String uid) => "${videoId}000$uid";

  // upload
  UploadTask uploadVideoFile(File video, String uid) {
    // save storage
    // /videos/userid/
    final fileRef = _storage.ref().child(
        "videos/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}");
    return fileRef.putFile(video);
  }

  // create video document
  Future<void> saveVideo(VideoModel data) async {
    await _db.collection("videos").add(data.toJson());
  }

  /// 비디오 내림차순으로 fetch
  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos({
    int? lastItemCreatedAt,
  }) {
    /*
    fetchVideos()
    1
    2
    fetchVideos(2)
    3
    4
    fetchVideos(4)
    5
    6
    */
    final query = _db
            .collection("videos")
            .orderBy("createdAt", descending: true)
            .limit(2) // 제한 개수
        ;
    if (lastItemCreatedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastItemCreatedAt]) // 시작 인덱스 다음
          .get();
    }
  }

  /// 좋아요 처리
  Future<void> toggleLikeVideo(String videoId, String uid) async {
    // 이미 좋아요 했는지 찾기
    final query = _db.collection("likes").doc(_makeLikesDocName(videoId, uid));
    final like = await query.get();
    // 좋아요 정보 없다면 추가하기
    if (!like.exists) {
      await query.set({
        "createAt": DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      // 있다면 삭제하기
      await query.delete();
    }
  }

  /// 좋아요 상태
  Future<bool> isLiked(String videoId, String uid) async {
    final like = await _db
        .collection("likes")
        .doc(_makeLikesDocName(videoId, uid))
        .get();
    return like.exists;
  }
}

final videosRepo = Provider(
  (ref) => VideosRepository(),
);
