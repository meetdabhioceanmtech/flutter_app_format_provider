import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/presentation/widgets/custom_snackbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_project/common/constants/common_router.dart';
import 'package:flutter_project/common/constants/translation_constants.dart';
import 'package:flutter_project/common/extension/size_box_extension.dart';
import 'package:flutter_project/common/extension/string_extension.dart';
import 'package:flutter_project/common/extension/theme_extension.dart';
import 'package:flutter_project/presentation/globals.dart';

class CommonWidget {
  static Widget imageBuilder({
    required String image,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadiusGeometry? borderRadius,
    double? roundBorderRadius,
    BoxShape shape = BoxShape.rectangle,
    Color? color,
  }) {
    if (image.isEmpty) return const SizedBox.shrink();
    double? h = height?.h;
    double? w = width?.w;

    Widget buildPlaceholder({required bool isError}) {
      return Center(
        child: isError ? const Icon(Icons.error) : CircularProgressIndicator(color: appConstants.primary1Color),
      );
    }

    Widget applyBorderRadius(Widget child) {
      if (shape == BoxShape.circle) return ClipOval(child: child);
      if (borderRadius != null || roundBorderRadius != null) {
        return ClipRRect(
          borderRadius: roundBorderRadius != null
              ? BorderRadius.circular(roundBorderRadius.r)
              : borderRadius ?? BorderRadius.zero,
          child: child,
        );
      }
      return child;
    }

    bool isSvg = image.toLowerCase().endsWith('.svg');

    if (image.startsWith('http')) {
      // Network image
      return applyBorderRadius(
        isSvg
            ? SvgPicture.network(
                image,
                width: w,
                height: h,
                fit: fit,
                semanticsLabel: 'A shark?!',
                placeholderBuilder: (BuildContext context) => buildPlaceholder(isError: false),
                colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
              )
            : CachedNetworkImage(
                imageUrl: image,
                width: w,
                height: h,
                color: color,
                fit: fit,
                errorListener: (value) => buildPlaceholder(isError: false),
                placeholder: (context, url) => buildPlaceholder(isError: false),
                errorWidget: (context, url, error) => buildPlaceholder(isError: true),
              ),
      );
    } else if (image.startsWith('asset')) {
      // Asset image
      return applyBorderRadius(
        isSvg
            ? SvgPicture.asset(
                image,
                width: w,
                height: h,
                fit: fit,
                placeholderBuilder: (_) => buildPlaceholder(isError: false),
                colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
              )
            : Image.asset(
                image,
                width: w,
                height: h,
                fit: fit,
                errorBuilder: (_, __, ___) => buildPlaceholder(isError: true),
              ),
      );
    } else if (image.startsWith('memory')) {
      // Memory image
      try {
        final base64String = image.split(',')[1];
        final bytes = base64.decode(base64String);
        return applyBorderRadius(
          Image.memory(
            bytes,
            width: w,
            height: h,
            fit: fit,
            errorBuilder: (_, __, ___) => buildPlaceholder(isError: true),
          ),
        );
      } catch (_) {
        return buildPlaceholder(isError: true);
      }
    } else {
      // File image
      return applyBorderRadius(
        Image.file(
          File(image),
          width: w,
          height: h,
          fit: fit,
          color: color,
          errorBuilder: (_, __, ___) => buildPlaceholder(isError: true),
        ),
      );
    }
  }

  static Future<dynamic> showAlertDialog({
    required BuildContext context,
    VoidCallback? onPositiveCallback,
    String? subTitle,
    String? title,
    Color? textColor,
    bool isTitle = false,
    VoidCallback? onNegativeCallback,
    List<Widget>? actions,
    TextStyle? titleTextStyle,
    TextStyle? contentTextStyle,
    Widget? titleWidget,
    Color? yesButtonTextColor,
    Color? yesButtonBgColor,
    Color? noButtonBgColor,
    Color? noButtonTextColor,
    EdgeInsets? insetPadding,
    EdgeInsetsGeometry? titlePadding,
  }) async {
    var data = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: insetPadding ?? EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          surfaceTintColor: appConstants.whiteBackgroundColor,
          backgroundColor: appConstants.whiteBackgroundColor,
          actionsAlignment: MainAxisAlignment.spaceBetween,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.r))),
          actionsPadding: EdgeInsets.zero,
          titlePadding: titlePadding ?? EdgeInsets.zero,
          title: titleWidget ??
              SizedBox(
                width: ScreenUtil().screenWidth * 0.9,
                child: Column(
                  children: [
                    CommonWidget.sizedBox(height: 20),
                    if (isTitle)
                      Column(
                        children: [
                          Center(
                            child: commonText(
                              text: title ?? '',
                              lineThrough: true,
                              style: titleTextStyle ??
                                  Theme.of(context).textTheme.subTitle2SemiboldHeading.copyWith(
                                        color: appConstants.neutral1Color,
                                        height: 1,
                                      ),
                            ),
                          ),
                          CommonWidget.sizedBox(height: 15),
                        ],
                      ),
                    CommonWidget.container(
                      child: CommonWidget.commonText(
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        text: subTitle ?? '',
                        style: contentTextStyle ??
                            Theme.of(context).textTheme.body2RegularHeading.copyWith(color: appConstants.primary1Color),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.r),
                      child: Row(
                        children: [
                          // Negative Button
                          Expanded(
                            child: commonButton(
                              context: context,
                              borderRadius: 10.r,
                              height: 40.h,
                              onTap: onNegativeCallback ?? () => CommonRouter.pop(),
                              alignment: Alignment.center,
                              text: TranslationConstants.no.translate(context),
                              textColor: noButtonTextColor ?? appConstants.primary1Color,
                              color: noButtonBgColor ?? appConstants.secondary6Color,
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                            ),
                          ),
                          SizedBox(width: 15.w),
                          // Positive Button
                          Expanded(
                            child: commonButton(
                              context: context,
                              borderRadius: 10.r,
                              height: 40.h,
                              onTap: onPositiveCallback ?? () => CommonRouter.pop(args: true),
                              alignment: Alignment.center,
                              text: TranslationConstants.yes.translate(context),
                              textColor: yesButtonTextColor ?? appConstants.whiteBackgroundColor,
                              color: yesButtonBgColor ?? appConstants.primary1Color,
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        );
      },
    );
    return data;
  }

  static Future<dynamic> showIosAlertDialog({
    required BuildContext context,
    required String title,
    required String contentTitle,
    void Function()? onPressedDone,
    String? backText,
    String? doneText,
    bool? outSideOnTap,
    TextAlign? textAlign,
    double contentTitleFontSize = 16,
    double buttonFontSize = 18,
    Color? contentTitleColor,
    Color? buttonFontColor,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: outSideOnTap ?? false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: padding(
            bottom: 5,
            child: commonText(
              text: title,
              style: Theme.of(context)
                  .textTheme
                  .subTitle3SemiboldHeading
                  .copyWith(color: appConstants.neutral1Color, height: 1),
            ),
          ),
          content: Text(
            contentTitle,
            textAlign: textAlign ?? TextAlign.center,
            style: Theme.of(context).textTheme.body2RegularHeading.copyWith(
                  color: contentTitleColor ?? appConstants.neutral1Color,
                  fontSize: contentTitleFontSize.sp,
                ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => CommonRouter.pop(),
                child: Text(
                  backText ?? TranslationConstants.cancel.translate(context),
                  style: TextStyle(
                    color: buttonFontColor ?? appConstants.primary1Color,
                    fontSize: buttonFontSize.sp,
                  ),
                )),
            TextButton(
              onPressed: () => onPressedDone ?? CommonRouter.pop(args: true),
              child: Text(
                doneText ?? TranslationConstants.delete.translate(context),
                style: TextStyle(
                  color: buttonFontColor ?? appConstants.primary1Color,
                  fontSize: buttonFontSize.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget commonText({
    required String text,
    bool bold = false,
    FontWeight? fontWeight,
    TextOverflow textOverflow = TextOverflow.ellipsis,
    Color? color,
    double? fontSize,
    double? letterSpacing,
    double? wordSpacing,
    TextAlign? textAlign,
    int maxLines = 1,
    bool lineThrough = false,
    Color? lineThroughColor,
    double? lineThroughThickness,
    bool underline = false,
    TextStyle? style,
    double? height,
  }) {
    return Text(
      text,
      overflow: textOverflow,
      textAlign: textAlign,
      maxLines: maxLines,
      style: style ??
          TextStyle(
            height: height,
            color: color ?? appConstants.neutral1Color,
            fontSize: fontSize?.sp ?? 20.sp,
            fontWeight: bold ? FontWeight.bold : fontWeight ?? FontWeight.normal,
            fontFamily: 'Poppins',
            letterSpacing: letterSpacing ?? 0.15,
            wordSpacing: wordSpacing ?? 0.1,
            decoration: lineThrough
                ? TextDecoration.lineThrough
                : underline
                    ? TextDecoration.underline
                    : TextDecoration.none,
            decorationColor: lineThroughColor ?? Colors.black38,
            decorationThickness: lineThroughThickness ?? 1.sp,
          ),
    );
  }

  static Widget container({
    double? width,
    double? height,
    Color color = Colors.white,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? margin,
    double marginAllSide = 0.0,
    EdgeInsetsGeometry? padding,
    double paddingAllSide = 0.0,
    bool isPaddingAllSide = false,
    BoxConstraints? constraints,
    Widget? child,
    bool isBorder = false,
    Color borderColor = Colors.black,
    double borderWidth = 1.0,
    double borderRadius = 0.0,
    double topLeft = 0.0,
    double topRight = 0.0,
    double bottomLeft = 0.0,
    double bottomRight = 0.0,
    bool isBorderOnlySide = false,
    BoxShape shape = BoxShape.rectangle,
    List<BoxShadow>? boxShadow,
  }) {
    return Container(
      width: width?.w,
      height: height?.h,
      margin: margin ?? EdgeInsets.all(marginAllSide.r),
      padding: padding ?? (isPaddingAllSide ? EdgeInsets.all(paddingAllSide.r) : null),
      alignment: alignment,
      constraints: constraints,
      decoration: BoxDecoration(
        shape: shape,
        border: isBorder ? Border.all(color: borderColor, width: borderWidth) : null,
        boxShadow: boxShadow,
        borderRadius: shape == BoxShape.rectangle
            ? (isBorderOnlySide
                ? BorderRadius.only(
                    topLeft: Radius.circular(topLeft.r),
                    topRight: Radius.circular(topRight.r),
                    bottomLeft: Radius.circular(bottomLeft.r),
                    bottomRight: Radius.circular(bottomRight.r),
                  )
                : BorderRadius.circular(borderRadius.r))
            : null,
        color: color,
      ),
      child: child,
    );
  }

  static Widget padding({
    required Widget child,
    EdgeInsetsGeometry? padding,
    double? paddingAllSide,
    bool isPaddingAllSide = false,
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? vertical,
    double? horizontal,
  }) {
    EdgeInsetsGeometry finalPadding = padding ??
        (isPaddingAllSide
            ? EdgeInsets.all((paddingAllSide ?? 0.0).r)
            : EdgeInsets.only(
                left: (left ?? horizontal ?? 0.0).w,
                top: (top ?? vertical ?? 0.0).h,
                right: (right ?? horizontal ?? 0.0).w,
                bottom: (bottom ?? vertical ?? 0.0).h,
              ));

    return Padding(
      padding: finalPadding,
      child: child,
    );
  }

  static Widget sizedBox({
    double? width,
    double? height,
    Widget? child,
  }) {
    if (child == null) {
      return SizedBox(
        height: height?.h,
        width: width?.w,
      );
    }

    return SizedBox(
      height: height?.h,
      width: width?.w,
      child: child,
    );
  }

  static Widget commonButton({
    required String text,
    required BuildContext context,
    required VoidCallback onTap,
    Color? textColor,
    double? borderRadius,
    double? width,
    Color? color,
    EdgeInsets? padding,
    double? height,
    TextStyle? style,
    bool isBorder = false,
    Color borderColor = Colors.black,
    double borderWidth = 1.0,
    AlignmentGeometry? alignment,
    double marginAllSide = 0.0,
    double topLeft = 0.0,
    double topRight = 0.0,
    double bottomLeft = 0.0,
    double bottomRight = 0.0,
    bool isBorderOnlySide = false,
    EdgeInsetsGeometry? margin,
    double paddingAllSide = 0.0,
    Widget? child,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: container(
        height: (height ?? 53).h,
        width: width != null ? width.h : ScreenUtil().screenWidth,
        margin: margin,
        alignment: alignment ?? Alignment.center,
        isBorder: isBorder,
        borderColor: borderColor,
        borderWidth: borderWidth,
        topLeft: topLeft,
        topRight: topRight,
        bottomLeft: bottomLeft,
        bottomRight: bottomRight,
        marginAllSide: marginAllSide,
        color: color ?? appConstants.primary1Color,
        isBorderOnlySide: isBorderOnlySide,
        padding: padding,
        borderRadius: borderRadius ?? appConstants.buttonRadius,
        paddingAllSide: paddingAllSide,
        child: child ??
            commonText(
              text: text,
              style: style ??
                  Theme.of(context).textTheme.body1SemiboldHeading.copyWith(
                        color: textColor ?? appConstants.whiteBackgroundColor,
                      ),
            ),
      ),
    );
  }

  static void keyboardClose() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static Widget textField({
    FocusNode? focusNode,
    Color? cursorColor,
    TextEditingController? controller,
    TextStyle? hintTextStyle,
    bool obscureText = false,
    bool isPrefixIcon = false,
    Widget? prefixWidget,
    String? prefixIconPath,
    int maxLength = 150,
    int minLines = 1,
    int maxLines = 1,
    TextInputAction? textInputAction,
    TextInputType? textInputType,
    String? hintText,
    double? prefixIconHeight,
    Color? focusedBorderColor,
    Color? fillColor,
    VoidCallback? onPrefixIconTap,
    Widget? suffixWidget,
    bool autoFocus = false,
    double? cursorHeight,
    TextAlignVertical? textAlignVertical,
    void Function(String)? onChanged,
    VoidCallback? onTap,
    ScrollController? scrollController,
    bool enabled = true,
    TextStyle? hintStyle,
    TextStyle? style,
    List<TextInputFormatter>? inputFormatters,
    required BuildContext context,
    String? Function(String?)? validator,
    EdgeInsetsGeometry? contentPadding,
    VoidCallback? onEditingComplete,
    Function(String, Map<String, dynamic>)? onAppPrivateCommand,
    bool filled = false,
    bool readOnly = false,
    AutovalidateMode autoValidateMode = AutovalidateMode.onUserInteraction,
  }) {
    return TextFormField(
      focusNode: focusNode,
      validator: validator,
      scrollController: scrollController,
      scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      inputFormatters: inputFormatters,
      onTapOutside: (_) => keyboardClose(),
      onEditingComplete: onEditingComplete,
      onAppPrivateCommand: onAppPrivateCommand,
      maxLines: maxLines,
      enabled: enabled,
      readOnly: readOnly,
      onChanged: onChanged,
      autovalidateMode: autoValidateMode,
      obscureText: obscureText,
      textInputAction: textInputAction ?? TextInputAction.done,
      controller: controller,
      keyboardType: textInputType ?? TextInputType.text,
      cursorColor: cursorColor ?? appConstants.primary1Color,
      cursorHeight: cursorHeight,
      autofocus: autoFocus,
      maxLength: maxLength,
      minLines: minLines,
      style: style,
      textAlignVertical: textAlignVertical ?? TextAlignVertical.center,
      onTap: onTap,
      decoration: InputDecoration(
        filled: filled,
        fillColor: fillColor ?? appConstants.primary7Color,
        prefixIcon: prefixWidget ??
            (isPrefixIcon && prefixIconPath != null
                ? Padding(
                    padding: EdgeInsets.all(13.r),
                    child: InkWell(
                      onTap: onPrefixIconTap,
                      child: imageBuilder(
                        image: prefixIconPath,
                        height: prefixIconHeight,
                      ),
                    ),
                  )
                : null),
        suffixIcon: suffixWidget,
        contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: focusedBorderColor ?? appConstants.primary1Color),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appConstants.redColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appConstants.grey1),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: focusedBorderColor ?? appConstants.primary1Color),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appConstants.redColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        disabledBorder: InputBorder.none,
        counterText: "",
        hintText: hintText,
        hintStyle: hintStyle ??
            Theme.of(context).textTheme.caption1RegularHeading.copyWith(
                  color: appConstants.grey2,
                ),
      ),
    );
  }

  static Widget loadingIos() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: CommonWidget.sizedBox(
          height: 300.h,
          width: 300.w,
          child: Center(
            child: CircularProgressIndicator(
              color: appConstants.whiteBackgroundColor,
              strokeWidth: 2,
              backgroundColor: appConstants.primary1Color,
              strokeCap: StrokeCap.round,
            ),
          ),
        ),
      ),
    );
  }

  static Widget toggleButton({
    Color? borderColor,
    required bool value,
    required void Function(bool) onChanged,
    Color? activeColor,
    FocusNode? focusNode,
    Color? activeTrackColor,
    bool? autofocus,
    DragStartBehavior? dragStartBehavior,
    Color? focusColor,
    Color? hoverColor,
    Color? inactiveThumbColor,
    double? splashRadius,
    Color? overlayColor,
    Color? inactiveTrackColor,
    Color? trackColor,
    void Function(bool)? onFocusChange,
    double scale = 0.75,
  }) {
    return Transform.scale(
      scaleX: scale,
      scaleY: scale,
      child: Switch(
        activeColor: activeColor ?? appConstants.primary1Color,
        activeTrackColor: activeTrackColor ?? appConstants.neutral1Color,
        inactiveTrackColor: inactiveTrackColor ?? appConstants.primary6Color,
        focusColor: focusColor ?? appConstants.primary6Color,
        hoverColor: hoverColor ?? appConstants.primary1Color,
        inactiveThumbColor: inactiveThumbColor ?? appConstants.primary1Color,
        trackColor: WidgetStatePropertyAll(trackColor ?? appConstants.primary6Color),
        overlayColor: WidgetStatePropertyAll(overlayColor ?? appConstants.primary6Color),
        trackOutlineColor: WidgetStatePropertyAll(overlayColor ?? appConstants.primary1Color),
        dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
        splashRadius: splashRadius ?? 10,
        focusNode: focusNode ?? FocusNode(),
        autofocus: autofocus ?? false,
        value: value,
        onChanged: onChanged,
        onFocusChange: onFocusChange,
      ),
    );
  }

  static Widget dataNotFound({
    required BuildContext context,
    String? imagePath,
    String? heading,
    String? subHeading,
    VoidCallback? onTap,
    String? buttonLabel,
    Color? buttonColor,
    EdgeInsetsGeometry? padding,
    Widget? actionButton,
    bool removeImage = false,
    Color? bgColor,
    Color? titleColor,
    Color? subTitleColor,
    double? height,
  }) {
    return Container(
      color: bgColor ?? Colors.white,
      alignment: Alignment.center,
      width: ScreenUtil().screenWidth,
      padding: padding ?? EdgeInsets.all(16.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!removeImage)
            CommonWidget.imageBuilder(
              image: imagePath ?? 'assets/svgs/common/data_not_found.svg',
              height: height ?? 130.h,
            ),
          CommonWidget.sizedBox(height: 20),
          CommonWidget.commonText(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            text: (heading ?? TranslationConstants.no_data_found.translate(context)).toCamelcase(),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .subTitle3SemiboldHeading
                .copyWith(color: titleColor ?? appConstants.neutral1Color),
          ),
          sizedBox(height: 10.h),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommonWidget.commonText(
              textAlign: TextAlign.center,
              text: subHeading?.replaceAll("==", "\n") ??
                  TranslationConstants.there_is_no_data_to_show_you.translate(context),
              maxLines: 2,
              style: Theme.of(context).textTheme.body2RegularHeading.copyWith(
                    color: subTitleColor ?? appConstants.grey1,
                  ),
            ),
          ),
          CommonWidget.sizedBox(height: 10),
          actionButton ??
              ActionChip(
                backgroundColor: buttonColor ?? appConstants.primary1Color,
                labelPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                label: Text(
                  buttonLabel ?? TranslationConstants.try_again.translate(context).toUpperCase(),
                  style: Theme.of(context).textTheme.body1BoldHeading.copyWith(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                ),
                onPressed: onTap ?? () {},
              )
        ],
      ),
    );
  }

  static Future<void> commonImageDialog({required String path, required BuildContext context}) async {
    if (path.isEmpty) {
      return CustomSnackbar.show(snackbarType: SnackbarType.ERROR, message: 'Image path is empty');
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close Button
              InkWell(
                splashColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                onTap: () => CommonRouter.pop(),
                child: Container(
                  alignment: Alignment.topRight,
                  height: 38.h,
                  width: double.infinity,
                  child: imageBuilder(
                    image: "assets/svgs/common/cancle_button.svg",
                    color: appConstants.whiteBackgroundColor,
                    height: 30.h,
                  ),
                ),
              ),

              // Image Display
              container(
                paddingAllSide: 2.5, // Keeps padding flexible
                borderRadius: 10.r,
                constraints: BoxConstraints(
                  maxHeight: ScreenUtil().screenHeight * 0.8, // Responsive max height
                  minWidth: ScreenUtil().screenWidth * 0.85, // Responsive min width
                ),
                child: imageBuilder(image: path), // Dynamically load image
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget imageButton({
    required String svgPicturePath,
    VoidCallback? onTap,
    double iconSize = 20.0,
    BoxFit boxFit = BoxFit.contain,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: imageBuilder(
        image: svgPicturePath,
        fit: boxFit,
        height: iconSize,
        color: color,
      ),
    );
  }

  static Future<dynamic> openBottomBar({
    required BuildContext context,
    required Widget child,
    double? heightFactor,
    Color? backgroundColor,
    bool isTitleBar = true,
    String? title,
    TextStyle? titleTextStyle,
    bool isTitleBold = false,
    double? titleFontSize,
    Color? dividerColor,
    double? dividerThickness,
    EdgeInsetsGeometry? padding,
    bool isDismissible = true,
  }) async {
    return await showModalBottomSheet(
      elevation: 0,
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      useSafeArea: true,
      enableDrag: true,
      builder: (context) {
        return Padding(
          padding: padding ?? MediaQuery.of(context).viewInsets,
          child: FractionallySizedBox(
            heightFactor: heightFactor ?? 0.7,
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(26.r), topRight: Radius.circular(26.r)),
              child: isTitleBar
                  ? CommonWidget.container(
                      color: appConstants.whiteBackgroundColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 15.h, bottom: 5.h, left: 15.w, right: 10.w),
                            child: Row(
                              children: [
                                Text(
                                  title ?? "",
                                  style: titleTextStyle ??
                                      Theme.of(context).textTheme.body2MediumHeading.copyWith(
                                            color: appConstants.primary1Color,
                                            fontWeight: isTitleBold ? FontWeight.bold : FontWeight.normal,
                                            fontSize: titleFontSize ?? 18.sp,
                                          ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () => CommonRouter.pop(),
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 25.r,
                                    color: appConstants.primary1Color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: appConstants.primary4Color,
                            thickness: dividerThickness ?? 2.h,
                          ),
                          CommonWidget.container(
                            color: appConstants.whiteBackgroundColor,
                            child: child,
                          )
                        ],
                      ),
                    )
                  : child,
            ),
          ),
        );
      },
    );
  }

  static Widget field({
    required BuildContext context,
    required TextEditingController controller,
    required String fieldTitle,
    required TextInputType textInputType,
    required String hintText,
    void Function()? onTap,
    String? Function(String?)? validator,
    bool isPassword = false,
    bool isPrefixIcon = false,
    bool obscureText = false,
    bool bottomSizedBoxAdd = true,
    Widget? suffixWidget,
    Widget? prefixWidget,
    String? initialValue,
    TextInputAction? textInputAction,
    void Function(String)? onChanged,
    Widget? child,
    int maxLines = 1,
    int minLines = 1,
    List<TextInputFormatter>? textInputFormatter,
    EdgeInsetsGeometry? contentPadding,
    int maxLength = 150,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonText(
          text: fieldTitle.toCamelcase(),
          style: Theme.of(context).textTheme.caption1MediumHeading.copyWith(
                color: appConstants.neutral1Color,
              ),
        ),
        4.sHeight,
        child ??
            textField(
              textInputAction: textInputAction ?? TextInputAction.next,
              inputFormatters: textInputFormatter,
              controller: controller,
              onTap: onTap,
              readOnly: onTap == null ? false : true,
              obscureText: obscureText,
              suffixWidget: suffixWidget,
              prefixWidget: isPrefixIcon ? prefixWidget : null,
              context: context,
              hintText: hintText,
              hintStyle: TextStyle(color: appConstants.primary6Color),
              textInputType: textInputType,
              contentPadding: contentPadding,
              validator: validator,
              maxLength: maxLength,
              minLines: minLines,
              maxLines: maxLines,
              onChanged: onChanged,
            ),
        if (bottomSizedBoxAdd) 14.sHeight,
      ],
    );
  }
}
