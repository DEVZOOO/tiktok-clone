import 'package:flutter/material.dart';

class FlashIcon extends StatelessWidget {
  final bool isActive;
  final Function onPressed;
  final IconData icon;
  const FlashIcon({
    super.key,
    required this.isActive,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: isActive ? Colors.amber.shade200 : Colors.white,
      onPressed: () => onPressed(),
      icon: Icon(icon),
    );
  }
}
