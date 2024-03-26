import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/password_screen.dart';
import 'package:tiktok_clone/features/authentication/widget/form_button.dart';

class EmailScreenArgs {
  final String username;

  EmailScreenArgs({required this.username});
}

/// 이메일 입력 화면
class EmailScreen extends StatefulWidget {
  // static String routeUrl = "email";
  // static String routeName = "email";
  final String username;

  const EmailScreen({
    super.key,
    required this.username,
  });

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _emailController = TextEditingController();

  String _email = '';

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      setState(() {
        _email = _emailController.text;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose(); // 연관된 이벤트리스너 모두 삭제

    super.dispose();
  }

  /// 이메일 형식 체크
  String? _isEmailValid() {
    // 빈값
    if (_email.isEmpty) {
      return null;
    }

    final regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (!regExp.hasMatch(_email)) {
      return 'Email not valid';
    }

    return null;
  }

  /// 바깥 클릭시 포커싱 해제
  void _onScaffoldTap() {
    FocusScope.of(context).unfocus(); // 모든 포커싱 해제
  }

  /// 이메일 입력 submit
  void _onSubmit() {
    // email 체크
    if (_email.isEmpty || _isEmailValid() != null) {
      return;
    }

    // 페이지 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as EmailScreenArgs;
    // print(args.username);
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

              Text(
                // 'What is your email, ${args.username}?',
                'What is your email, ${widget.username}?',
                style: const TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w700,
                ),
              ),

              Gaps.v16,

              // input
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress, // 키보드 형식
                autocorrect: false, // 자동완성 사용하지 않음
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  hintText: 'Email',
                  errorText: _isEmailValid(),
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

              Gaps.v28,

              // button
              GestureDetector(
                onTap: _onSubmit,
                child: FormButton(
                  text: 'Next',
                  disabled: _email.isEmpty || _isEmailValid() != null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
