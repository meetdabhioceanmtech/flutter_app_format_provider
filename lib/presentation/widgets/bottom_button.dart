import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_project/common/constants/translation_constants.dart';
import 'package:flutter_project/common/extention/string_extension.dart';
import 'package:flutter_project/common/extention/theme_extension.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/widgets/common_widget.dart';

Widget bottomButton({
  required BuildContext context,
  required VoidCallback onTap,
  String? text,
  bool isShortButton = true,
  bool isAddNew = true,
  bool isSubmitBtton = false,
  Widget? sortButtonCreate,
  Widget? longButtonCreate,
  bool boxShadow = true,
  bool isDisable = false,
  Widget? child,
}) {
  return Container(
    height: 90.h,
    width: ScreenUtil().screenWidth,
    decoration: BoxDecoration(
      boxShadow: boxShadow
          ? [
              BoxShadow(color: appConstants.primary7Color, blurRadius: 10, spreadRadius: 5),
            ]
          : [],
      color: appConstants.whiteBackgroundColor,
    ),
    child: child ??
        GestureDetector(
          onTap: !isDisable ? onTap : null,
          child: Center(
            child: Container(
              height: 52.h,
              padding: (!isShortButton && isSubmitBtton) ? null : EdgeInsets.symmetric(horizontal: 25.w),
              margin: (isShortButton && !isSubmitBtton) ? null : EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: appConstants.primary1Color,
                // boxShadow: [
                //   BoxShadow(
                //     color:  appConstants.primary1Color.withOpacity(0.3),
                //     offset: const Offset(0, 3),
                //     blurRadius: 3,
                //     spreadRadius: 0,
                //   ),
                // ],
              ),
              child: isSubmitBtton
                  ? Center(
                      child: longButtonCreate ??
                          CommonWidget.commonText(
                            text: text ?? TranslationConstants.submit.translate(context),
                            style: Theme.of(context).textTheme.subTitle3BoldHeading.copyWith(
                                  fontSize: 18,
                                  color: appConstants.whiteBackgroundColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                    )
                  : sortButtonCreate ??
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isAddNew
                              ? CommonWidget.imageBuilder(image: "assets/photos/svg/customer/add_new.svg", height: 20.h)
                              : const SizedBox.shrink(),
                          CommonWidget.sizedBox(width: 10),
                          CommonWidget.commonText(
                            style: Theme.of(context).textTheme.body1BoldHeading.copyWith(
                                  color: appConstants.whiteBackgroundColor,
                                  fontWeight: FontWeight.w600,
                                  // fontSize: 18,
                                ),
                            text: text ?? TranslationConstants.add_new.translate(context),
                          )
                        ],
                      ),
            ),
          ),
        ),
  );
}
