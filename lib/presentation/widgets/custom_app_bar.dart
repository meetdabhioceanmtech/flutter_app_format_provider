import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_project/common/constants/common_router.dart';
import 'package:flutter_project/common/extention/string_extension.dart';
import 'package:flutter_project/common/extention/theme_extension.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/widgets/common_widget.dart';

PreferredSizeWidget? customAppBar({
  required BuildContext context,
  VoidCallback? onTap,
  String? title,
  Widget? actions,
  Widget? titleWidget,
  Color? textColor,
  Color? appBarColor,
  Color? iconColor,
  bool backArrow = true,
  bool actionButton = false,
  VoidCallback? backArrowTap,
  VoidCallback? actionButtonOnTap,
  IconData? actionnButtonIcon,
  bool titleCenter = true,
  double? toolbarHeight,
  double? elevation,
  double? actionnButtonSize,
}) {
  return AppBar(
    toolbarHeight: toolbarHeight ?? 55.h,
    surfaceTintColor: appConstants.whiteBackgroundColor,
    scrolledUnderElevation: 0.0,
    backgroundColor: appBarColor ?? appConstants.primary1Color,
    leadingWidth: backArrow == true ? 45 : 0,
    elevation: elevation ?? 0,
    leading: backArrow
        ? IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            icon: CommonWidget.imageBuilder(
              image: "assets/svgs/common/back_arrow.svg",
              width: 18.w,
              height: 18.w,
              color: iconColor ?? appConstants.whiteBackgroundColor,
            ),
            onPressed: onTap ??
                () {
                  CommonWidget.keyboardClose(context: context);
                  CommonRouter.pop();
                },
          )
        : CommonWidget.sizedBox(),
    centerTitle: titleCenter,
    title: titleWidget ??
        CommonWidget.commonText(
          text: title?.toCamelcase() ?? '',
          style: Theme.of(context)
              .textTheme
              .subTitle3MediumHeading
              .copyWith(color: textColor ?? appConstants.whiteBackgroundColor),
        ),
    actions: [
      actionButton == true
          ? Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: actionButtonOnTap,
                splashColor: Colors.transparent,
                icon: Icon(
                  actionnButtonIcon ?? Icons.info_outline,
                  color: appConstants.neutral1Color,
                  size: actionnButtonSize ?? 35.sp,
                ),
              ),
            )
          : actions ?? const SizedBox.shrink()
    ],
  );
}
