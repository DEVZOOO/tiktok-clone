import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/chats_screen.dart';
import 'package:tiktok_clone/features/videos/views/video_recording_screen.dart';

class NotificationsProvider extends FamilyAsyncNotifier<void, BuildContext> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// 로그인한 유저 정보에 token 업데이트
  Future<void> updateToken(String token) async {
    final user = ref.read(authRepo).user;
    _db.collection("users").doc(user!.uid).update({"token": token});
  }

  /// 유저 알림
  Future<void> initListener(BuildContext context) async {
    // 알림 권한 요청
    final permission = await _messaging.requestPermission();
    // 완전히 거부
    if (permission.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }

    // 앱 열려있을때 listener - foreground 상태
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      if (kDebugMode) {
        print('Foreground');
        print(event.notification?.title);
      }

      final title = event.notification?.title ?? '';
      final cont = event.notification?.body ?? '';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Text(title),
              Text(cont),
            ],
          ),
          showCloseIcon: true,
        ),
      );
    });

    // Background 상태
    FirebaseMessaging.onMessageOpenedApp.listen((noti) {
      if (kDebugMode) {
        print('Background Noti');
      }

      // 알림보낼때 다른 데이터 숨겨서 보낼수 있음
      // print(noti.data['screen']);
      context.pushNamed(ChatsScreen.routeName);
    });

    // Terminated 상태
    // terminated 상태에서 알림 누르면 실행되어 반환됨
    final notification = await _messaging.getInitialMessage();
    if (notification != null) {
      if (kDebugMode) {
        print('Terminated Noti');
      }

      // print(notification.data['screen']);
      context.pushNamed(VideoRecordingScreen.routeName);
    }
  }

  @override
  FutureOr build(BuildContext context) async {
    final token = await _messaging.getToken();
    if (token == null) {
      print('token is null');
      return;
    }

    print('token is $token');
    await updateToken(token);

    await initListener(context);

    // token은 변할수도 있음
    _messaging.onTokenRefresh.listen((newToken) async {
      await updateToken(newToken);
    });
  }
}

final notificationsProvider =
    AsyncNotifierProvider.family<NotificationsProvider, void, BuildContext>(
        () => NotificationsProvider());
