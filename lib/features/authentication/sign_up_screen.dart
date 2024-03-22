import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';
import 'package:tiktok_clone/features/authentication/widget/auth_button.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils.dart';

/// 회원가입 화면
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  /// 바깥 클릭시 포커싱 해제
  void _onScaffoldTap(BuildContext context) {
    FocusScope.of(context).unfocus(); // 모든 포커싱 해제
  }

  /// login 링크 탭
  void _onLoginTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  /// 이메일 화면 이동
  void _onEmailTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const UsernameScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(Localizations.localeOf(context));
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
                      S.of(context).signUpTitle("TikTok"),
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
                              icon: const FaIcon(FontAwesomeIcons.apple),
                              text: S.of(context).appleButton,
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
