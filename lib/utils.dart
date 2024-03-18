import 'package:flutter/cupertino.dart';

/// dark mode 여부 반환
bool isDartMode(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.dark;
