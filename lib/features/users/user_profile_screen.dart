import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/settings/settings_screen.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/users/widget/avatar.dart';
import 'package:tiktok_clone/features/users/widget/persistent_tab_bar.dart';
import 'package:tiktok_clone/features/users/widget/user_account.dart';

/// user profile
class UserProfileScreen extends ConsumerStatefulWidget {
  final String username;
  final String tab;

  const UserProfileScreen({
    super.key,
    required this.username,
    required this.tab,
  });

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final TextEditingController _bioTextEditingController =
      TextEditingController();
  final TextEditingController _linkTextEditingController =
      TextEditingController();

  /// setting
  void _onGearPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ref.watch(usersProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) {
            return Scaffold(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              body: SafeArea(
                child: DefaultTabController(
                  length: 2,
                  initialIndex: widget.tab == "likes" ? 1 : 0,
                  child: NestedScrollView(
                    // header
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      /*
                SliverAppBar(
                  // floating: true, // 첫번째 요소가 아니지만 스크롤업할때 appBar 보여짐
                  pinned: true, // 스크롤 많이해도 appBar 계속 표시
                  // snap: true, // 스크롤 업 조금만 해도 appBar 전부 표시, floating: true와 같이 사용
                  // stretch: true, // 최상단에서 스크롤업시 animation 효과
                  backgroundColor: Colors.teal,
                  elevation: 1,
                  collapsedHeight: 80,
                  expandedHeight: 200,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      'assets/images/devzooit_profile.png',
                      fit: BoxFit.cover,
                    ),
                    title: const Text('Hello'),
                    stretchModes: const [
                      StretchMode.blurBackground,
                      StretchMode.zoomBackground,
                    ],
                  ),
                ),
            
                // sliver가 아닌 일반적인 위젯 추가할때 사용
                const SliverToBoxAdapter(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 20,
                      ),
                    ],
                  ),
                ),
            
                SliverFixedExtentList(
                  // custom scroll 하위 위젯 만들기
                  delegate: SliverChildBuilderDelegate(
                    childCount: 50, // 생성할 아이템 개수
                    (context, index) => Container(
                      color: Colors.amber[100 * (index % 9)],
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('Item $index'),
                      ),
                    ),
                  ),
                  itemExtent: 100,
                ),
                SliverPersistentHeader(
                  delegate: CustomDelegate(),
                  pinned: true,
                ),
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    childCount: 50,
                    (context, index) {
                      return Container(
                        color: Colors.blue[100 * (index % 9)],
                        child: Align(
                          alignment: Alignment.center,
                          child: Text('Item $index'),
                        ),
                      );
                    },
                  ),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100,
                    mainAxisSpacing: Sizes.size20,
                    crossAxisSpacing: Sizes.size20,
                    childAspectRatio: 1,
                  ),
                ),
              */

                      // title
                      SliverAppBar(
                        title: Text(data.name),
                        actions: [
                          // link, bio 수정
                          IconButton(
                            onPressed: () async {
                              /*
                            
                            final data = await showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: const Text("Edit"),
                                  content: Column(
                                    children: [
                                      Container(
                                        child: const Text("BIO"),
                                      ),
                                      Container(child: const Text("Link"),),
                                    ],
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      isDestructiveAction: true,
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text("Cancel"),
                                    ),
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Edit"),
                                    ),
                                  ],
                                );
                              },
                            );
                            print(data);
                            */

                              final result = await showDialog(
                                context: context,
                                builder: (context) {
                                  _bioTextEditingController.value =
                                      TextEditingValue(text: data.bio);
                                  _linkTextEditingController.value =
                                      TextEditingValue(text: data.link);

                                  return AlertDialog(
                                    actions: [
                                      const CloseButton(),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, "OK");
                                        },
                                        child: const Text("OK"),
                                      ),
                                    ],
                                    content: Form(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // BIO
                                          TextFormField(
                                            controller:
                                                _bioTextEditingController,
                                            decoration: InputDecoration(
                                              prefixIcon: const Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [Text("BIO")],
                                              ),
                                              suffixIcon: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      _bioTextEditingController
                                                              .value =
                                                          TextEditingValue
                                                              .empty;
                                                    },
                                                    icon: const FaIcon(
                                                        FontAwesomeIcons
                                                            .eraser),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // LINK
                                          TextFormField(
                                            controller:
                                                _linkTextEditingController,
                                            decoration: InputDecoration(
                                              prefixIcon: const Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [Text("LINK")],
                                              ),
                                              suffixIcon: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      _linkTextEditingController
                                                              .value =
                                                          TextEditingValue
                                                              .empty;
                                                    },
                                                    icon: const FaIcon(
                                                        FontAwesomeIcons
                                                            .eraser),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );

                              if (result != null) {
                                final newBio = _bioTextEditingController.text;
                                final newLink = _linkTextEditingController.text;

                                // profile 수정
                                ref
                                    .read(usersProvider.notifier)
                                    .upodateProfile(newBio, newLink);
                              }
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.pencil,
                              size: Sizes.size20,
                            ),
                          ),
                          // 설정
                          IconButton(
                            onPressed: _onGearPressed,
                            icon: const FaIcon(
                              FontAwesomeIcons.gear,
                              size: Sizes.size20,
                            ),
                          ),
                        ],
                      ),

                      // 일반적인 위젯
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Gaps.v20,

                            // profile image
                            Avatar(
                              name: data.name,
                              uid: data.uid,
                              hasAvatar: data.hasAvatar,
                            ),

                            Gaps.v20,

                            // account
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '@${data.name}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Sizes.size18,
                                  ),
                                ),
                                Gaps.h5,
                                FaIcon(
                                  FontAwesomeIcons.solidCircleCheck,
                                  size: Sizes.size16,
                                  color: Colors.blue.shade500,
                                ),
                              ],
                            ),

                            Gaps.v24,

                            // info
                            SizedBox(
                              height: Sizes.size44,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // ## Challenge 1
                                  const UserAccount(
                                    number: '97',
                                    title: 'Following',
                                  ),
                                  VerticalDivider(
                                    width: Sizes.size32, // 사이 공간
                                    thickness: Sizes.size1, // 선의 굵기
                                    color: Colors.grey.shade400,
                                    indent: Sizes.size14, // 시작점
                                    endIndent: Sizes.size14, // 끝나는점
                                  ),
                                  const UserAccount(
                                    number: '10.5M',
                                    title: 'Followers',
                                  ),
                                  VerticalDivider(
                                    width: Sizes.size32, // 사이 공간
                                    thickness: Sizes.size1, // 선의 굵기
                                    color: Colors.grey.shade400,
                                    indent: Sizes.size14, // 시작점
                                    endIndent: Sizes.size14, // 끝나는점
                                  ),
                                  const UserAccount(
                                    number: '194.5M',
                                    title: 'Likes',
                                  ),
                                ],
                              ),
                            ),

                            Gaps.v5,

                            // button
                            // ## challenge 2
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Follows
                                Flexible(
                                  child: FractionallySizedBox(
                                    widthFactor: .5,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: Sizes.size12),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(Sizes.size4),
                                        ),
                                      ),
                                      child: const Text(
                                        'Follow',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Gaps.h5,

                                // youtube
                                Container(
                                  width: Sizes.size44,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: Sizes.size12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: const Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.youtube,
                                      size: Sizes.size20,
                                    ),
                                  ),
                                ),

                                Gaps.h5,

                                // arrow
                                Container(
                                  width: Sizes.size44,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: Sizes.size12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: const Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.sortDown,
                                      size: Sizes.size20,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Gaps.v10,

                            // desc
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.size32),
                              child: Text(
                                data.bio,
                                textAlign: TextAlign.center,
                              ),
                            ),

                            Gaps.v5,

                            // link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.link,
                                  size: Sizes.size12,
                                ),
                                Gaps.h4,
                                Text(
                                  data.link,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),

                            Gaps.v20,
                          ],
                        ),
                      ),

                      // Tabs
                      SliverPersistentHeader(
                        delegate: PersistentTabBar(),
                        pinned: true,
                      ),
                    ],

                    // scrollable
                    body: TabBarView(
                      children: [
                        GridView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior
                                  .onDrag, // drag할대마다 키보ㅡ드 자동 사라짐
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: size.width > Breakpoints.lg
                                ? 5
                                : 3, // column 몇개 가질지
                            crossAxisSpacing: size.width > Breakpoints.lg
                                ? Sizes.size4
                                : Sizes.size2, // column 사이 간격
                            mainAxisSpacing: size.width > Breakpoints.lg
                                ? Sizes.size4
                                : Sizes.size2, // row 사이 간격
                            childAspectRatio:
                                9 / 14, // 이미지 아래 다른 요소들이 있어서 세로 키움
                          ),
                          padding: EdgeInsets.zero,
                          itemCount: 20,
                          // ## challenge 1
                          itemBuilder: (context, index) => Stack(
                            children: [
                              // image
                              Positioned.fill(
                                child: AspectRatio(
                                  aspectRatio: 9 / 14,
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                        'assets/images/devzooit_profile.png',
                                    image:
                                        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1473&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // video count
                              const Positioned(
                                bottom: 0,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: Sizes.size7,
                                    bottom: Sizes.size4,
                                  ),
                                  child: Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.play,
                                        color: Colors.white,
                                        size: Sizes.size14,
                                      ),
                                      Gaps.h7,
                                      Text(
                                        '4.1K',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Sizes.size14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Center(child: Text('two')),
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

/*
class CustomDelegate extends SliverPersistentHeaderDelegate {
  /// widget, maxExtent, minExtent 영향받음
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.indigo,
      child: const FractionallySizedBox(
        heightFactor: 1,
        child: Center(
          child: Text('Title'),
        ),
      ),
    );
  }

  /// 최대높이
  @override
  double get maxExtent => 150;

  /// 최소높이, 스크롤 다운할때 최소 높이 정할수 있음
  @override
  double get minExtent => 80;

  /// minExtent, minExtent 만 변경하고 싶으면 true, build에서 다른 위젯을 반환한다면 false,
  /// 대부분 false임
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
*/