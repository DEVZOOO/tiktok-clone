import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:tiktok_clone/utils.dart';

/// 계정 생성 trigger
class SignupViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;

  @override
  FutureOr<void> build() {
    // 멤버변수 초기화
    _authRepo = ref.read(authRepo);
  }

  Future<void> signup(BuildContext context) async {
    state = const AsyncValue.loading(); // 로딩중
    final form = ref.read(signupForm);
    /*
    await _authRepo.signUp(form['email'], form['password']);
    state = const AsyncValue.data(null);  // 로딩 끝남 - expost 하지 않으면 null
    */

    // 위의 동작을 한꺼번에 해줌
    // 실행하고 에러있다면 state에 넣어주고 성공했으면 결과값 state에 넣어줌
    state = await AsyncValue.guard(
      () async => await _authRepo.signUp(
        form['email'],
        form['password'],
      ),
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
