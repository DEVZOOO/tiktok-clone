import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';
import 'package:tiktok_clone/features/authentication/view_models/social_auth_view_model.dart';
import 'package:tiktok_clone/features/authentication/widget/auth_button.dart';
import 'package:tiktok_clone/generated/l10n.dart';

/// 회원가입 화면
class SignUpScreen extends ConsumerWidget {
  static String routeUrl = "/";
  static const routeName = "signup";
  const SignUpScreen({super.key});

  /// 바깥 클릭시 포커싱 해제
  void _onScaffoldTap(BuildContext context) {
    FocusScope.of(context).unfocus(); // 모든 포커싱 해제
  }

  /// login 링크 탭
  void _onLoginTap(BuildContext context) async {
    /*
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
    // print("user came back");
    */

    // final result = await Navigator.of(context).pushNamed(LoginScreen.routeName);

    context.pushNamed(LoginScreen.routeName);
    // 사용자를 다른 화면으로 보내주는데 screen stack 관련된 것 모두 무시
    // 화면들이 stack 처럼 쌓여있는 형태로 동작하는데 stack에 push하는게 아니라 독립적인 화면으로 이동시킴
    // pop을 사용할 수 없음!
    // appBar에 뒤로가기 버튼 없어짐! 완전히 다른 화면으로 이동하고 싶을때, stack과의 관계를 끊고 새로 시작함
    // context.go(LoginScreen.routeName);
  }

  /// 이메일 화면 이동
  void _onEmailTap(BuildContext context) {
    // 페이지 애니메이션
    /*
    Navigator.of(context).push(
      // MaterialPageRoute(builder: (context) => const UsernameScreen()),
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 1), // 다음화면으로 갈때 duration
        reverseTransitionDuration:
            const Duration(seconds: 1), // 이전화면으로 돌아올때 duration, 애니메이션 반대로 실행됨!
        pageBuilder: (context, animation, secondaryAnimation) =>
            const UsernameScreen(),
        // child : pageBuilder가 리턴하는 위젯
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Animation<double> 이 아닌 다른 타입의 애니메이션 사용하고 싶을 경우
          final offsetAnimation = Tween(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation);

          final opacityAnimation = Tween(
            begin: 0.5,
            end: 1.0,
          ).animate(animation);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: opacityAnimation,
              child: child,
            ),
          );
        },
      ),
    );
    */

    // Navigator.of(context).pushNamed(UsernameScreen.routeName);

    // context.push(UsernameScreen.routeName);
    // context.push("/users/lynn?show=likes");
    // context.pushNamed(UsernameScreen.routeName);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UsernameScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print(Localizations.localeOf(context));
    return OrientationBuilder(
      builder: (context, orientation) {
        // if (orientation == Orientation.landscape) {
        //   return const Scaffold(
        //     body: Center(
        //       child: Text('Plz rotate ur phone.'),
        //     ),
        //   );
        // }
        return GestureDetector(
          onTap: () => _onScaffoldTap(context),
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size40,
                ),
                child: Column(
                  children: [
                    Gaps.v80,
                    Text(
                      S.of(context).signUpTitle("TikTok", DateTime.now()),
                      style: const TextStyle(
                        fontSize: Sizes.size24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Gaps.v20,
                    Opacity(
                      opacity: .7,
                      child: Text(
                        S.of(context).signUpSubtitle(2),
                        style: const TextStyle(
                          fontSize: Sizes.size16,
                          // color: isDartMode(context)
                          //     ? Colors.grey.shade300
                          //     : Colors.black45,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Gaps.v40,

                    // buttons
                    // 세로방향
                    if (orientation == Orientation.portrait) ...[
                      AuthButton(
                        icon: const FaIcon(FontAwesomeIcons.user),
                        text: S.of(context).emailPasswordButton,
                        onTap: () => _onEmailTap(context),
                      ),
                      Gaps.v16,
                      AuthButton(
                        icon: const FaIcon(FontAwesomeIcons.apple),
                        text: S.of(context).appleButton,
                      ),
                      Gaps.v16,
                      AuthButton(
                        icon: const FaIcon(FontAwesomeIcons.github),
                        text: 'Continue with Github',
                        onTap: () => ref
                            .read(socialAuthProvider.notifier)
                            .githubSignIn(context),
                      ),
                    ],

                    // 가로방향
                    if (orientation == Orientation.landscape)
                      Row(
                        children: [
                          Expanded(
                            child: AuthButton(
                              icon: const FaIcon(FontAwesomeIcons.user),
                              text: S.of(context).emailPasswordButton,
                              onTap: () => _onEmailTap(context),
                            ),
                          ),
                          Gaps.h16,
                          Expanded(
                            child: AuthButton(
                              icon: const FaIcon(FontAwesomeIcons.github),
                              text: 'Continue with Github',
                              onTap: () => ref
                                  .read(socialAuthProvider.notifier)
                                  .githubSignIn(context),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              // elevation: 10,
              // shadowColor: Colors.black,
              // surfaceTintColor: Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: Sizes.size28,
                  bottom: Sizes.size64,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(S.of(context).alreadyHaveAnAccount),
                    Gaps.v5,
                    GestureDetector(
                      onTap: () => _onLoginTap(context),
                      child: Text(
                        S.of(context).login("male"),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
