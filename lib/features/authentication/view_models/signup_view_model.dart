import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/utils.dart';

/// 계정 생성 trigger
class SignupViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;

  @override
  FutureOr<void> build() {
    // 멤버변수 초기화
    _authRepo = ref.read(authRepo);
  }

  /// 회원가입 처리
  Future<void> signup(BuildContext context) async {
    state = const AsyncValue.loading(); // 로딩중
    final form = ref.read(signupForm);
    /*
    await _authRepo.signUp(form['email'], form['password']);
    state = const AsyncValue.data(null);  // 로딩 끝남 - expost 하지 않으면 null
    */

    final users = ref.read(usersProvider.notifier);

    // 위의 동작을 한꺼번에 해줌
    // 실행하고 에러있다면 state에 넣어주고 성공했으면 결과값 state에 넣어줌
    state = await AsyncValue.guard(
      () async {
        final userCredential = await _authRepo.emailSignUp(
          form['email'],
          form['password'],
        );

        // guard 안에 있으므로 정상 실행되면 유저가 무조건 생성되었음
        // 생성된 유저 정보로 profile 생성
        await users.createProfile(
          userCredential,
          form['name'],
          form['birthday'],
        );
      },
    );

    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.goNamed(InterestsScreen.routeName);
    }
  }
}

// 밖에서 수정할 수 있게 해줌
/// 회원가입 정보
final signupForm = StateProvider((ref) => {});
final signupProvider = AsyncNotifierProvider<SignupViewModel, void>(
  () => SignupViewModel(),
);
