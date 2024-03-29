import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
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
