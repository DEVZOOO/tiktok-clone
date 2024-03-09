import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/birthday_screen.dart';
import 'package:tiktok_clone/features/authentication/widget/form_button.dart';

/*
class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('Skip'),
            Expanded(
              child: Text(
                'Sign up',
                textAlign: TextAlign.center,
              ),
            ),
            FaIcon(FontAwesomeIcons.circleQuestion),
          ],
        ),
      ),
      body: const Placeholder(),
    );
  }
}
*/

/// 이메일 입력 화면
class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();

  String _password = ''; // 비밀번호 값
  bool _obscureText = true; // 비밀번호 숨김여부

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(() {
      setState(() {
        _password = _passwordController.text;
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose(); // 연관된 이벤트리스너 모두 삭제

    super.dispose();
  }

  /// 비밀번호 형식 체크
  bool _isPasswordValid() {
    return _isPasswordLengthValid() && _isPasswordPatternValid();
  }

  /// 비밀번호 형식 길이 체크
  bool _isPasswordLengthValid() {
    return _password.isNotEmpty && _password.length > 8;
  }

  /// 비밀번호 형식 문자 체크
  bool _isPasswordPatternValid() {
    final regExp =
        RegExp(r'(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]');
    return regExp.hasMatch(_password);
  }

  /// 바깥 클릭시 포커싱 해제
  void _onScaffoldTap() {
    FocusScope.of(context).unfocus(); // 모든 포커싱 해제
  }

  /// 비밀번호 입력 submit
  void _onSubmit() {
    // 비밀번호 체크
    if (!_isPasswordValid()) {
      return;
    }

    // 페이지 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BirthdayScreen(),
      ),
    );
  }

  /// x 버튼
  void _onClearTap() {
    _passwordController.clear();
  }

  /// 비밀번호 show/hide
  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign up'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v40,

              const Text(
                'Password',
                style: TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w700,
                ),
              ),

              Gaps.v16,

              // input
              TextField(
                controller: _passwordController,
                autocorrect: false, // 자동완성 사용하지 않음
                cursorColor: Theme.of(context).primaryColor,
                obscureText: _obscureText, // 비밀번호
                decoration: InputDecoration(
                  // 아이콘
                  suffix: Row(
                    mainAxisSize: MainAxisSize.min, // 사이즈 최소로
                    children: [
                      GestureDetector(
                        onTap: _onClearTap,
                        child: FaIcon(
                          FontAwesomeIcons.solidCircleXmark,
                          color: Colors.grey.shade500,
                          size: Sizes.size20,
                        ),
                      ),
                      Gaps.h16,
                      GestureDetector(
                        onTap: _toggleObscureText,
                        child: FaIcon(
                          _obscureText
                              ? FontAwesomeIcons.eye
                              : FontAwesomeIcons.eyeSlash,
                          color: Colors.grey.shade500,
                          size: Sizes.size20,
                        ),
                      ),
                    ],
                  ),
                  hintText: 'Make it strong!',
                  enabledBorder: UnderlineInputBorder(
                    // 입력시 border
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    // focus시 border
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                onEditingComplete: () => _onSubmit(), // 키보드에서 done/완료 클릭시
              ),

              Gaps.v10,

              // 조건안내
              const Text(
                'Your Password must have:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              Gaps.v10,

              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.circleCheck,
                    size: Sizes.size20,
                    color: _isPasswordLengthValid()
                        ? Colors.green
                        : Colors.grey.shade400,
                  ),
                  Gaps.h5,
                  const Text('8 to 20 characters'),
                ],
              ),

              Gaps.v5,

              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.circleCheck,
                    size: Sizes.size20,
                    color: _isPasswordPatternValid()
                        ? Colors.green
                        : Colors.grey.shade400,
                  ),
                  Gaps.h5,
                  const Text('Letters, numbers, and special characters'),
                ],
              ),

              Gaps.v28,

              // button
              GestureDetector(
                onTap: _onSubmit,
                child: FormButton(
                  text: 'Next',
                  disabled: !_isPasswordValid(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
