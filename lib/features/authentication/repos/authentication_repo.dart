import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationRepository {
  // firebase instance
  final FirebaseAuth _firebaseAuth =
      FirebaseAuth.instance; // main()에서 init하는 시점에 이미 인스턴스 생성댐

  // getter
  User? get user => _firebaseAuth.currentUser;
  bool get isLoggedIn => user != null;

  /// 회원가입 - 이메일, 비번으로 계정 생성
  Future<UserCredential> emailSignUp(String email, String password) async {
    // 가입 성공시 firebaseAuth에서 반환받은 데이터에 접근하여 UserProfile 생성해야 하므로 return 처리
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// 로그인처리
  Future<void> signIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// 로그아웃
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// 유저 인증상태 변경
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  /// github 로그인
  Future<void> githubSignIn() async {
    // firebase에서 지원하는 provider
    await _firebaseAuth.signInWithProvider(GithubAuthProvider());
  }
}

final authRepo = Provider((ref) => AuthenticationRepository());

// 유저 인증상태 변경 감지
final authState = StreamProvider(
  (ref) {
    // authRepo 읽기
    final repo = ref.read(authRepo);
    return repo.authStateChanges();
  },
);
