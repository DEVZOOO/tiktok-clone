// 통합 테스트
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tiktok_clone/firebase_options.dart';
import 'package:tiktok_clone/main.dart';

void main() {
  // main.dart 의 WidgetsFlutterBinding 을 테스트버전으로
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // step1. setup - 설정
  setUp(() async {
    // Firebase 초기화
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // logout 상태 만들기
    await FirebaseAuth.instance.signOut();
  });

  // step2. test / group - 테스트
  // 앱 전체 랜더링 - 좀 오래걸림
  testWidgets("Create Account Flow", (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: TikTokApp(),
      ),
    );

    await tester.pumpAndSettle(); // 애니메이션 지나가기 기다림림

    // 텍스트 있는지 확인
    expect(find.text("Sign up for TikTok"), findsOneWidget);

    final login = find.text("Login");
    expect(login, findsOneWidget);

    // 특정 위젯 클릭
    await tester.tap(login);

    await tester.pumpAndSettle(const Duration(seconds: 10)); // 기다릴 시간 설정 가능

    final signUp = find.text("Sign up");
    expect(signUp, findsOneWidget);

    await tester.tap(signUp);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // 회원가입 화면 진입
    final emailBtn = find.text('Use email & password');
    expect(emailBtn, findsOneWidget);

    await tester.tap(emailBtn);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // username 화면 진입
    final usernameInput = find.byType(TextField).first;
    await tester.enterText(usernameInput, "test");

    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.tap(find.text("Next"));

    await tester.pumpAndSettle(const Duration(seconds: 5));

    // email 화면 진입

    final emailInput = find.byType(TextField).first;
    await tester.enterText(emailInput, "test@testing.com");

    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.tap(find.text("Next"));

    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Password 화면 진입
    final passwordInput = find.byType(TextField).first;
    await tester.enterText(passwordInput, "qwer1234!");

    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // birthday 화면 진입
    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Interest 화면 진입
    expect(find.text("Choose your interests"), findsOneWidget);
  });

  // step3. tear down - 테스트 끝난 후 실행
}
