import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notification = false;

  void _onNotificationChange(bool? newVal) {
    if (newVal == null) {
      return;
    }

    setState(() {
      _notification = !_notification;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Breakpoints.sm),
          child: ListView(
            children: [
              // alert
              ListTile(
                title: const Text('Log out (IOS)'),
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
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
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

              //
              Checkbox(
                value: _notification,
                onChanged: _onNotificationChange,
              ),
              Switch(
                value: _notification,
                onChanged: _onNotificationChange,
              ),
              Switch.adaptive(
                value: _notification,
                onChanged: _onNotificationChange,
              ),
              CupertinoSwitch(
                value: _notification,
                onChanged: _onNotificationChange,
              ),
              SwitchListTile(
                value: _notification,
                onChanged: _onNotificationChange,
                title: const Text('SwitchListTile'),
              ),
              SwitchListTile.adaptive(
                value: _notification,
                onChanged: _onNotificationChange,
                title: const Text('SwitchListTile'),
                subtitle: const Text('adaptive'),
              ),
              CheckboxListTile(
                value: _notification,
                onChanged: _onNotificationChange,
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
              const AboutListTile(),
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

                  if (!mounted) return;

                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (kDebugMode) {
                    print(time);
                  }

                  if (!mounted) return;
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
            ],
          ),
        ),
      ),
    );
  }
}
