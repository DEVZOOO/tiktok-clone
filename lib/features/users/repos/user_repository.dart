import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // create profile
  Future<void> createProfile(UserProfileModel profile) async {
    // 디렉토리 구조처럼 users/uid/{데이터}
    await _db
        .collection("users")
        .doc(profile.uid) // unique PK, DB id
        .set(profile.toJson());
  }

  /// get profile
  Future<Map<String, dynamic>?> findProfile(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    return doc.data();
  }

  // update profile - ## Challenge

  /// user 정보 변경
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).update(data);
  }

  /// upload
  Future<void> uploadAvatar(File file, String fileName) async {
    final fileRef = _storage
            .ref() // 내 앱 - storage 연결하는 ref
            .child("avatars/$fileName") // 하위에 새로운 ref 생성 - 파일을 위한 공간 생성
        ;
    // storage 공간에 업로드
    final task = await fileRef.putFile(file);
  }
}

final userRepo = Provider((ref) => UserRepository());
