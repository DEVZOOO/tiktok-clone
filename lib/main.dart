import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/router.dart';

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
    // S.load(const Locale("ko"));
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false, // 애뮬레이터 실행시 오른쪽위에 debug 표시 여부
      title: 'Tiktok clone',
      themeMode: ThemeMode.system, // ThemeMode.dart : 강제 dark모드 설정
      localizationsDelegates: const [
        // 번역 파일들
        S.delegate,
        // flutter 기본 위젯
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("en"),
        Locale("ko"),
      ],

      /*
        AppLocalizations.delegate, // 생성한 번역파일

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      */

      // 라이트모드
      theme: ThemeData(
        brightness: Brightness.light,
        // 폰트, 색상만 지정함 기본폰트(사이즈, 두께 등등 없음)
        textTheme: Typography.blackMountainView,
        // google fonts textTheme
        // textTheme: GoogleFonts.wellfleetTextTheme(),
        // material design generator
        /*
        textTheme: TextTheme(
          displayLarge: GoogleFonts.contrailOne(
              fontSize: 86, fontWeight: FontWeight.w300, letterSpacing: -1.5),
          displayMedium: GoogleFonts.contrailOne(
              fontSize: 54, fontWeight: FontWeight.w300, letterSpacing: -0.5),
          displaySmall: GoogleFonts.contrailOne(
              fontSize: 43, fontWeight: FontWeight.w400),
          headlineMedium: GoogleFonts.contrailOne(
              fontSize: 31, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          headlineSmall: GoogleFonts.contrailOne(
              fontSize: 22, fontWeight: FontWeight.w400),
          titleLarge: GoogleFonts.contrailOne(
              fontSize: 18, fontWeight: FontWeight.w500, letterSpacing: 0.15),
          titleMedium: GoogleFonts.contrailOne(
              fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.15),
          titleSmall: GoogleFonts.contrailOne(
              fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.1),
          bodyLarge: GoogleFonts.roboto(
              fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
          bodyMedium: GoogleFonts.roboto(
              fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          labelLarge: GoogleFonts.roboto(
              fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
          bodySmall: GoogleFonts.roboto(
              fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
          labelSmall: GoogleFonts.roboto(
              fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
        ),
        */
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primaryColor: const Color(0xFFE9435A),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFE9435A),
        ), // input 커서 전역 설정
        scaffoldBackgroundColor: Colors.white, // scaffold 전역 설정
        // splashColor: Colors.transparent, // 앱 전체에서 클릭시 splash 효과 삭제
        // highlightColor: Colors.transparent, // long tab
        // appBar 전역 설정
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey.shade500,
          indicatorColor: Colors.black,
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.black,
        ),
        bottomAppBarTheme: BottomAppBarTheme(color: Colors.grey.shade50),
        useMaterial3: false,
      ),

      // 다크모드
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFFE9435A),
        textTheme: Typography.whiteMountainView,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFE9435A),
        ),
        /*
        textTheme: GoogleFonts.wellfleetTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme, // 다크모드 설정
        ),
        */
        appBarTheme: AppBarTheme(
          centerTitle: true,
          color: Colors.grey.shade900,
          surfaceTintColor: Colors.grey.shade900,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.grey.shade100,
          ),
          iconTheme: IconThemeData(
            color: Colors.grey.shade100,
          ),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade700,
        ),
        bottomAppBarTheme: BottomAppBarTheme(color: Colors.grey.shade900),
        useMaterial3: false,
      ),

      // home: const SignUpScreen(),
      // home: const MainNavigationScreen(),
      // route 사용
      /*
      initialRoute: SignUpScreen.routeName,
      routes: {
        SignUpScreen.routeName: (context) => const SignUpScreen(),
        UsernameScreen.routeName: (context) => const UsernameScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        EmailScreen.routeName: (context) => const EmailScreen(),
      },
      */
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
