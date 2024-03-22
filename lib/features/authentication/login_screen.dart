import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/login_form_screen.dart';
import 'package:tiktok_clone/features/authentication/widget/auth_button.dart';
import 'package:tiktok_clone/utils.dart';

class LoginScreen extends StatelessWidget {
  static String routeName = "/login";
  const LoginScreen({super.key});

  /// signup 링크 탭
  void _onSignupTap(BuildContext context) {
    // Navigator.of(context).pop(); // Navigator 가장 상단 화면 stack에서 제거
    context.pop();
  }

  /// 이메일 로그인 버튼 탭
  void _onEmailLoginTab(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginFormScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size40,
          ),
          child: Column(
            children: [
              Gaps.v80,
              const Text(
                'Log in up for TikTok',
                style: TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v20,
              const Opacity(
                opacity: .7,
                child: Text(
                  'Manage your account, check notifications, comment on videos, and more.',
                  style: TextStyle(
                    fontSize: Sizes.size16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // buttons
              Gaps.v40,
              AuthButton(
                icon: const FaIcon(FontAwesomeIcons.user),
                text: 'Use email & password',
                onTap: () => _onEmailLoginTab(context),
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
      bottomNavigationBar: Container(
        // elevation: 10,
        // shadowColor: Colors.black,
        // surfaceTintColor: Colors.grey.shade50,
        color: isDarkMode(context) ? null : Colors.grey,
        child: Padding(
          padding: const EdgeInsets.only(
            top: Sizes.size28,
            bottom: Sizes.size64,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an acount?"),
              Gaps.h5,
              GestureDetector(
                onTap: () => _onSignupTap(context),
                child: Text(
                  'Sign up',
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
    );
  }
}
