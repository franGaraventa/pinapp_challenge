import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/colors.dart';

class LikeIcon extends StatelessWidget {
  const LikeIcon({
    super.key,
    this.isEnabled = false,
    this.disabledIcon = CupertinoIcons.heart,
    this.enabledIcon = CupertinoIcons.heart_fill,
    this.enabledColor = ColorTheme.secondaryColor,
    this.disabledColor = Colors.black,
    required this.onTap,
  });

  final bool isEnabled;
  final IconData disabledIcon;
  final IconData enabledIcon;
  final Color enabledColor;
  final Color disabledColor;
  final Function(bool) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap.call(isEnabled),
      child: Icon(
        isEnabled ? enabledIcon : disabledIcon,
        color: isEnabled ? enabledColor : disabledColor,
      ),
    );
  }
}
