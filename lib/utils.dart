import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// dark mode 여부 반환
bool isDarkMode(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.dark;

/// firebase 에러 발생시 snackbar 표시
void showFirebaseErrorSnack(BuildContext context, Object? error) =>
    ScaffoldMessenger.of(context).showSnackBar(
      // flutter widget
      SnackBar(
        content: Text(
          (error as FirebaseException).message ?? "Something went wrong.",
        ),
        showCloseIcon: true,
      ),
    );

/// 유저 프로필 이미지 경로 반환
String getProfileImageUrl(String uid) =>
    "https://firebasestorage.googleapis.com/v0/b/judy-tiktok-clone.appspot.com/o/avatars%2F$uid?alt=media&token=029a2805-8f99-445e-ae0d-c93c02ad9ab5";
