import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';
import 'package:tiktok_clone/features/authentication/widget/auth_button.dart';

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
                const Text(
                  'Sign up for TikTok',
                  style: TextStyle(
                    fontSize: Sizes.size24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gaps.v20,
                const Text(
                  'Create a profile, follow other accounts, make your own videos, and more.',
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    color: Colors.black45,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.v40,

                // buttons
                AuthButton(
                  icon: const FaIcon(FontAwesomeIcons.user),
                  text: 'Use email & password',
                  onTap: () => _onEmailTap(context),
                ),
                Gaps.v16,
                const AuthButton(
                  icon: FaIcon(FontAwesomeIcons.apple),
                  text: 'Continue with Apple',
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 10,
          shadowColor: Colors.black,
          surfaceTintColor: Colors.grey.shade50,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Sizes.size28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an acount? '),
                Gaps.v5,
                GestureDetector(
                  onTap: () => _onLoginTap(context),
                  child: Text(
                    'Log in',
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
  }
}
