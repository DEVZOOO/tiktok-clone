import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repos/user_repository.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _usersRepository;
  late final AuthenticationRepository _authRepository;

  @override
  FutureOr<UserProfileModel> build() async {
    // repository 초기화
    _usersRepository = ref.read(userRepo);
    _authRepository = ref.read(authRepo);

    // 2. 이미 계정 있는 경우 - 로그인한 유저 - DB 데이터 반환
    if (_authRepository.isLoggedIn) {
      final profile =
          await _usersRepository.findProfile(_authRepository.user!.uid);
      if (profile != null) {
        return UserProfileModel.fromJson(profile);
      }
    }

    // 1. 계정 없는 경우 - 신규 계정 생성 - empty model 반환
    return UserProfileModel.empty();
  }

  /// 신규 프로필 정보 생성 (with [UserCredentials])
  Future<void> createProfile(
      UserCredential credential, String name, String birthday) async {
    // 없으면 에러처리 - guard에서 핸들링하므로 에러 던져도 됨
    if (credential.user == null) {
      throw Exception("Account not created");
    }

    // loading 상태로 변경
    state = const AsyncValue.loading();

    // model 생성
    final profile = UserProfileModel(
      hasAvatar: false,
      email: credential.user!.email ?? "anon@anon.com",
      bio: "",
      link: "",
      uid: credential.user!.uid,
      name: credential.user!.displayName ?? name,
      birthday: birthday,
    );

    // firebase firestore 생성
    await _usersRepository.createProfile(profile);

    // provider data 넣기
    state = AsyncValue.data(profile);
  }

  /// avatar 이미지 업로드시 firestore 변경
  Future<void> onAvatarUpload() async {
    // state 업데이트 - loading 상태로 변경하지 않음ㅂ
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: true));
    // storage 업데이트
    await _usersRepository.updateUser(state.value!.uid, {
      "hasAvatar": true,
    });
  }

  /// bio, link 업데이트
  Future<void> upodateProfile(String bio, String link) async {
    // 상태값 변경
    state = AsyncValue.data(
      state.value!.copyWith(bio: bio, link: link),
    );

    // storage 업데이트 처리
    await _usersRepository.updateUser(
      state.value!.uid,
      {
        "bio": bio,
        "link": link,
      },
    );
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);
