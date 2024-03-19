import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

final tabs = [
  "Top",
  "Users",
  "Videos",
  "Sounds",
  "LIVE",
  "Shopping",
  "Brands",
];

/// Discover 화면
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _textEditingController =
      TextEditingController(text: "initail Text"); // default

  bool _isTextFieldEmpty = true;

  void _onSearchChanged(String value) {
    // _textEditingController.value.text.isNotEmpty
    if (value != '') {
      _isTextFieldEmpty = false;
    } else {
      _isTextFieldEmpty = true;
    }

    setState(() {});
  }

  void _onSearchSubmitted(String value) {
    print('_onSearchSubmitted $value');
  }

  /// 탭 메뉴 탭
  /// challenge 1 - 탭 변경시 키보드 unfocus
  void _onTabChanged(int index) {
    FocusScope.of(context).unfocus();
  }

  /// clear 버튼 탭
  /// challenge 2 - custom input 구현
  void _onClearTap() {
    _textEditingController.clear();
    setState(() {
      _isTextFieldEmpty = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // cupertino search
          /*
          title: CupertinoSearchTextField(
            controller: _textEditingController,
            onChanged: _onSearchChanged,
            onSubmitted: _onSearchSubmitted,
          ),
          */
          /// challenge 2 - custom input 구현
          title: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.sm),
            child: CupertinoTextField(
              controller: _textEditingController,
              decoration: BoxDecoration(
                color: isDarkMode(context)
                    ? Colors.grey.shade800
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(
                  Sizes.size8,
                ),
              ),
              style: TextStyle(
                color: isDarkMode(context) ? Colors.white : Colors.black,
              ),

              onChanged: _onSearchChanged,

              // 검색아이콘
              prefix: Container(
                padding: const EdgeInsets.only(left: Sizes.size10),
                child: FaIcon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: Sizes.size16,
                  color: Colors.grey.shade500,
                ),
              ),

              // clear 아이콘
              suffix: _isTextFieldEmpty
                  ? Container()
                  : GestureDetector(
                      onTap: _onClearTap,
                      child: Container(
                        padding: const EdgeInsets.only(right: Sizes.size10),
                        child: FaIcon(
                          FontAwesomeIcons.solidCircleXmark,
                          size: Sizes.size16,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
            ),
          ),

          elevation: 1,
          bottom: TabBar(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size16),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Sizes.size16,
            ),
            isScrollable: true,
            splashFactory: NoSplash.splashFactory, // 탭 클릭시 wave 효과 삭제
            tabs: [
              for (var tab in tabs)
                Tab(
                  text: tab,
                ),
            ],

            onTap: _onTabChanged,
          ),
        ),
        body: TabBarView(
          children: [
            GridView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
                  .onDrag, // drag할대마다 키보드 자동 사라짐
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: width > Breakpoints.lg ? 5 : 2, // column 몇개 가질지
                crossAxisSpacing: width > Breakpoints.lg
                    ? Sizes.size10
                    : Sizes.size5, // column 사이 간격
                mainAxisSpacing: width > Breakpoints.lg
                    ? Sizes.size10
                    : Sizes.size5, // row 사이 간격
                childAspectRatio: 9 / 20, // 이미지 아래 다른 요소들이 있어서 세로 키움
              ),
              padding: const EdgeInsets.all(Sizes.size6),
              itemCount: 20,
              itemBuilder: (context, index) => LayoutBuilder(
                builder: (context, constraints) => Column(
                  children: [
                    Container(
                      // border 처리 위함
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.size4),
                      ),
                      child: AspectRatio(
                        aspectRatio: 9 / 16,
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/devzooit_profile.png',
                          image:
                              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1473&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Gaps.v10,

                    //
                    const Text(
                      'This is a very long caption for my tiktok that im upload just now currently.',
                      style: TextStyle(
                        fontSize: Sizes.size16,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                      maxLines: 2, // 최대 로우
                      overflow: TextOverflow.ellipsis, // 줄임표
                    ),

                    Gaps.v5,

                    if (constraints.maxWidth < 200 ||
                        constraints.maxWidth > 250)
                      DefaultTextStyle(
                        style: TextStyle(
                          color: isDarkMode(context)
                              ? Colors.grey.shade300
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 12,
                              backgroundImage: NetworkImage(
                                // 'https://avatars.githubusercontent.com/u/104175767?v=4',
                                'https://img1.daumcdn.net/thumb/C428x428/?scode=mtistory2&fname=https%3A%2F%2Ftistory3.daumcdn.net%2Ftistory%2F6960833%2Fattach%2F62e6c9210f464678ba605d521bac5b48',
                              ),
                            ),
                            Gaps.h4,
                            const Expanded(
                              child: Text(
                                'my avatar is going to be very long',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Gaps.h4,
                            FaIcon(
                              FontAwesomeIcons.heart,
                              size: Sizes.size16,
                              color: Colors.grey.shade600,
                            ),
                            Gaps.h2,
                            const Text('2.5M'),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
            for (var tab in tabs.skip(1))
              Center(
                child: Text(
                  tab,
                  style: const TextStyle(
                    fontSize: Sizes.size16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
