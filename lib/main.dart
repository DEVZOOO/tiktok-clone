import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/inbox/activity_screen.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:tiktok_clone/features/main_navigation/main_navigation_screen.dart';

void main() async {
  // 앱 실행전에 binding 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 방향 강제
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  // 라이트모드/다크모드, 얘는 각 화면별로 설정할 수 있음
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark,
  );

  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 애뮬레이터 실행시 오른쪽위에 debug 표시 여부
      title: 'Tiktok clone',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primaryColor: const Color(0xFFE9435A),
        textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFE9435A)), // input 커서 전역 설정
        scaffoldBackgroundColor: Colors.white, // scaffold 전역 설정
        // splashColor: Colors.transparent, // 앱 전체에서 클릭시 splash 효과 삭제
        // highlightColor: Colors.transparent, // long tab
        // appBar 전역 설정
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
        ),
        useMaterial3: false,
      ),
      // home: const SignUpScreen(),
      home: const MainNavigationScreen(),
    );
  }
}

class LayoutBuilderCodeLab extends StatelessWidget {
  const LayoutBuilderCodeLab({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width * .5,
        child: LayoutBuilder(
          /// [constraints] box가 얼마나 커질수 있는지, 최댓값
          builder: (context, constraints) => Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            color: Colors.teal,
            child: Center(
              child: Text(
                '${size.width} / ${constraints.maxWidth}',
                style: const TextStyle(color: Colors.white, fontSize: 99),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
