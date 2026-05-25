import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OtherLoginOption extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final FaIconData icon;
  final VoidCallback action ;
  const OtherLoginOption({
    super.key,
    required this.backgroundColor,
    required this.iconColor,
    required this.icon, required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: backgroundColor,
      onPressed: action,
      child: FaIcon(icon, color: iconColor),
    );
  }
}
