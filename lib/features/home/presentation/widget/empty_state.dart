import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/colors.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.assetRoute,
    this.assetScale = 2.0,
    this.isRetryable = false,
    this.onRetryTap,
    this.errorMsg = "",
    this.assetColor,
    this.retryIconSize = 40.0,
    this.retryIconColor = ColorTheme.primaryColor,
    this.retryIconData = CupertinoIcons.refresh_thick,
  });

  final String assetRoute;
  final double assetScale;
  final bool isRetryable;
  final Function? onRetryTap;
  final String errorMsg;
  final Color? assetColor;
  final double retryIconSize;
  final Color retryIconColor;
  final IconData retryIconData;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            assetRoute,
            scale: assetScale,
            color: assetColor,
          ),
          errorMsg.isNotEmpty
              ? Text(
                  errorMsg,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: ColorTheme.primaryColor,
                    fontSize: 18.0,
                  ),
                )
              : const SizedBox.shrink(),
          isRetryable
              ? InkWell(
                  onTap: () => onRetryTap?.call(),
                  child: Icon(
                    retryIconData,
                    size: retryIconSize,
                    color: retryIconColor,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
