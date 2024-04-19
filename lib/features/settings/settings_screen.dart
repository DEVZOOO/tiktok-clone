import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/theme_configuration/is_darkmode.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';

class SettingsScreen extends ConsumerWidget {
// class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  /*
  bool _notification = false;

  void _onNotificationChange(bool? newVal) {
    if (newVal == null) {
      return;
    }

    setState(() {
      _notification = !_notification;
    });
  }
  */
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.sm,
          ),
          child: ListView(
            children: [
              // ## Challenge 라이트모드/다크모드
              ValueListenableBuilder(
                valueListenable: isDarkMode,
                builder: (context, value, child) => SwitchListTile.adaptive(
                  value: isDarkMode.value,
                  onChanged: (value) => isDarkMode.value = !isDarkMode.value,
                  title: const Text("Use Dark Mode"),
                  subtitle: const Text("다크모드를 사용합니다."),
                ),
              ),

              // 음량조절
              // 1) InheritedWidget + StatefulWidget
              /*
              SwitchListTile.adaptive(
                value: VideoConfigData.of(context).autoMute,
                onChanged: (value) => VideoConfigData.of(context).toggleMuted(),
                title: const Text("Auto Mute"),
                subtitle: const Text("Videos will be muted by default."),
              ),
              */
              // 2) ChangeNotifier
              /*
              AnimatedBuilder(
                animation: videoConfig,
                builder: (context, child) => SwitchListTile.adaptive(
                  value: videoConfig.autoMute,
                  onChanged: (value) => videoConfig.toggleAutoMute(),
                  title: const Text("Auto Mute"),
                  subtitle: const Text("Videos will be muted by default."),
                ),
              ),
              */
              // 3) ValueNotifier
              /*
              AnimatedBuilder(
                animation: videoConfig,
                builder: (context, child) => SwitchListTile.adaptive(
                  value: videoConfig.value,
                  onChanged: (value) => videoConfig.value = !videoConfig.value,
                  title: const Text("Auto Mute"),
                  subtitle: const Text("Videos will be muted by default."),
                ),
              ),
              // or
              ValueListenableBuilder(
                valueListenable: videoConfig,
                builder: (context, value, child) {
                  return SwitchListTile.adaptive(
                    value: videoConfig.value,
                    onChanged: (value) =>
                        videoConfig.value = !videoConfig.value,
                    title: const Text("Auto Mute"),
                    subtitle: const Text("Videos will be muted by default."),
                  );
                },
              ),
              */
              // 4) provider
              /*
              SwitchListTile.adaptive(
                value: context.watch<VideoConfig>().isMuted,
                onChanged: (value) =>
                    context.read<VideoConfig>().toggleIsMuted(),
                title: const Text("Auto Mute"),
                subtitle: const Text("Videos will be muted by default."),
              ),
              */
              // viewmodel
              // 음소거
              SwitchListTile.adaptive(
                // provider
                // value: context.watch<PlaybackConfigViewModel>().muted,
                value: ref.watch(playbackConfigProvider).muted,
                onChanged: (value) {
                  // context.read<PlaybackConfigViewModel>().setMuted(value);
                  ref.read(playbackConfigProvider.notifier).setMuted(value);
                },
                title: const Text("Mute Video"),
                subtitle: const Text("Videos will be muted by default."),
              ),
              // 자동재생
              SwitchListTile.adaptive(
                // value: context.watch<PlaybackConfigViewModel>().autoplay,
                value: ref.watch(playbackConfigProvider).autoplay,
                onChanged: (value) {
                  // context.read<PlaybackConfigViewModel>().setAutoplay(value);
                  ref.read(playbackConfigProvider.notifier).setAutoplay(value);
                },
                title: const Text("Autoplay"),
                subtitle: const Text("Video will start playing automatically."),
              ),

              // alert
              ListTile(
                title: const Text('Log out'),
                textColor: Colors.red,
                onTap: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Text("Are you sure?"),
                        content: const Text('Plx dont go'),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('NO'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            child: const Text('YES'),
                            onPressed: () {
                              ref.read(authRepo).signOut();
                              Navigator.of(context).pop();
                              context.go("/");
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              /*
              ListTile(
                title: const Text('Log out (Android)'),
                textColor: Colors.red,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        icon: const FaIcon(FontAwesomeIcons.skull),
                        title: const Text("Are you sure?"),
                        content: const Text('Plx dont go'),
                        actions: [
                          IconButton(
                            icon: const FaIcon(FontAwesomeIcons.x),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: const Text('YES'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              // bottom sheet
              ListTile(
                title: const Text('Log out (IOS / bottom)'),
                textColor: Colors.red,
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return CupertinoActionSheet(
                        title: const Text("Are you sure?"),
                        message: const Text('Please doooont gooooo'),
                        actions: [
                          CupertinoActionSheetAction(
                            isDefaultAction:
                                true, // 이게 기본 옵션이라는 거 표시, 폰트 두꼐 굵어짐
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Not log out'),
                          ),
                          CupertinoActionSheetAction(
                            isDestructiveAction: true,
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Yes Plz,'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              */

              //
              /*
              Checkbox(
                value: false,
                onChanged: (value) {},
              ),
              Switch(
                value: false,
                onChanged: (value) {},
              ),
              Switch.adaptive(
                value: false,
                onChanged: (value) {},
              ),
              CupertinoSwitch(
                value: false,
                onChanged: (value) {},
              ),
              SwitchListTile(
                value: false,
                onChanged: (value) {},
                title: const Text('SwitchListTile'),
              ),
              SwitchListTile.adaptive(
                value: false,
                onChanged: (value) {},
                title: const Text('SwitchListTile'),
                subtitle: const Text('adaptive'),
              ),
              CheckboxListTile(
                value: false,
                onChanged: (value) {},
                title: const Text('CheckboxListTile'),
                activeColor: Theme.of(context).primaryColor,
              ),
              ListTile(
                onTap: () => showAboutDialog(
                  context: context,
                  applicationVersion: '1.0',
                  applicationLegalese: "All rights reserved. Please don't copy",
                ),
                title: const Text(
                  'About',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text('About this app....'),
              ),
              */
              const AboutListTile(
                applicationVersion: "0.0.1",
              ),
              /*
              ListTile(
                title: const Text('What is your birthday?'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );

                  if (kDebugMode) {
                    print(date);
                  }

                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (kDebugMode) {
                    print(time);
                  }

                  final booking = await showDateRangePicker(
                    context: context,
                    // modal에 wrapper 만들어줌
                    // 현재는 theme만 변경
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData(
                          colorScheme: ColorScheme.fromSeed(
                              seedColor: Theme.of(context).primaryColor),
                        ),
                        child: child!,
                      );
                    },
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );

                  if (kDebugMode) {
                    print(booking);
                  }
                },
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}
