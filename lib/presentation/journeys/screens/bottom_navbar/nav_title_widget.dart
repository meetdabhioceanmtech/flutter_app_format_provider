import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_project/common/extention/theme_extension.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/widgets/common_widget.dart';

class NavItems {
  final int index;
  final String icon;
  final String title;

  const NavItems({
    required this.index,
    required this.icon,
    required this.title,
  }) : assert(index >= 0, 'index cannot be nagative');
}

class NavTitleWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isSelected;
  final String iconPath;
  final String activatedIcon;

  const NavTitleWidget({
    super.key,
    required this.title,
    required this.onTap,
    this.isSelected = false,
    this.iconPath = '',
    this.activatedIcon = '',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: appConstants.whiteBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonWidget.imageBuilder(
              image: iconPath,
              color: isSelected ? appConstants.primary1Color : appConstants.neutral5Color,
              width: 28.r,
              height: 28.r,
            ),
            SizedBox(height: 6.h),
            Text(
              title,
              style: Theme.of(context).textTheme.caption2MediumHeading.copyWith(
                    color: isSelected ? appConstants.primary1Color : appConstants.neutral5Color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
