import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/email_screen.dart';
import 'package:tiktok_clone/features/authentication/view_models/signup_view_model.dart';
import 'package:tiktok_clone/features/authentication/widget/form_button.dart';

/// username 입력 화면
class UsernameScreen extends ConsumerStatefulWidget {
  static String routeUrl = "username";
  static String routeName = "username";
  const UsernameScreen({super.key});

  @override
  ConsumerState<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends ConsumerState<UsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();

  String _username = '';

  @override
  void initState() {
    super.initState();

    _usernameController.addListener(() {
      setState(() {
        _username = _usernameController.text;
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose(); // 연관된 이벤트리스너 모두 삭제

    super.dispose();
  }

  /// 바깥 클릭시 포커싱 해제
  void _onScaffoldTap() {
    FocusScope.of(context).unfocus(); // 모든 포커싱 해제
  }

  /// Next 버튼 클릭 이벤트
  void _onNextTap() {
    // username 체크
    if (_username.isEmpty) {
      return;
    }

    /*
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EmailScreen(),
      ),
    );
    */

    /*
    Navigator.pushNamed(
      context,
      EmailScreen.routeName,
      arguments: EmailScreenArgs(username: _username), // 파라미터
    );
    */

    // context.push(
    //   EmailScreen.routeName,
    //   extra: EmailScreenArgs(username: _username),
    // );

    // context.pushNamed(
    //   EmailScreen.routeName,
    //   extra: EmailScreenArgs(
    //     username: _username,
    //   ),
    // );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailScreen(username: _username),
      ),
    );
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
                'Create username',
                style: TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w700,
                ),
              ),

              Gaps.v8,

              const Text(
                'You can always change this later.',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),

              Gaps.v16,

              // input
              TextField(
                controller: _usernameController,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  hintText: 'Username',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),

              Gaps.v16,

              // button
              GestureDetector(
                onTap: _onNextTap,
                child: FormButton(text: 'Next', disabled: _username.isEmpty),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
