import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/widget/form_button.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';

/// 생일 입력 화면
class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key});

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  final TextEditingController _birthdayController = TextEditingController();

  DateTime initialDate =
      DateTime.now().subtract(const Duration(days: 365 * 12)); // 현재시간 - 12년

  @override
  void initState() {
    super.initState();
    // 초기값 설정
    _setTextFieldDate(initialDate);
  }

  @override
  void dispose() {
    _birthdayController.dispose(); // 연관된 이벤트리스너 모두 삭제

    super.dispose();
  }

  /// TextField 데이터 설정
  void _setTextFieldDate(DateTime date) {
    final textDate = date.toString().split(" ").first;
    _birthdayController.value = TextEditingValue(text: textDate);
  }

  /// Next 버튼 클릭 이벤트
  void _onNextTap() {
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(builder: (context) => const InterestsScreen()),
    //   (route) => false,
    // );

    // 뒤로가기 안댐
    context.pushReplacementNamed(InterestsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              "When's your birthday?",
              style: TextStyle(
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w700,
              ),
            ),

            Gaps.v8,

            const Text(
              "Your birthday won't be shown publicly.",
              style: TextStyle(
                color: Colors.black54,
              ),
            ),

            Gaps.v16,

            // input
            TextField(
              enabled: false, // 항상 비활성화
              controller: _birthdayController,
              cursorColor: Theme.of(context).primaryColor,
              decoration: InputDecoration(
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
              child: const FormButton(text: 'Next', disabled: false),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 300,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date, // 날짜 선택
          initialDateTime: initialDate, // 최초시간
          maximumDate: initialDate, // 최대시간
          onDateTimeChanged: _setTextFieldDate,
        ),
      ),
    );
  }
}
