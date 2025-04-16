import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_project/common/constants/common_router.dart';
import 'package:flutter_project/common/constants/translation_constants.dart';
import 'package:flutter_project/common/extention/string_extension.dart';
import 'package:flutter_project/common/extention/theme_extension.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/widgets/common_widget.dart';

class CommonImagePickTextFeild extends StatefulWidget {
  final bool isMultipleImagePick;
  final bool? isEdit;
  final bool? showImageDialog;
  final bool? isShowImag;
  final Color? borderColor;
  final double? borderRadius;
  final double? heightFactor;
  final double? buttonHeight;
  final String? pathToDisplay;
  final VoidCallback? onTextTap;
  final VoidCallback? onImageSelect;
  const CommonImagePickTextFeild({
    super.key,
    required this.isMultipleImagePick,
    this.isEdit = false,
    this.isShowImag = true,
    this.borderColor,
    this.borderRadius,
    this.heightFactor,
    this.pathToDisplay,
    this.buttonHeight,
    this.onTextTap,
    this.onImageSelect,
    this.showImageDialog,
  });

  @override
  State<CommonImagePickTextFeild> createState() => _CommonImagePickTextFeildState();
}

class _CommonImagePickTextFeildState extends State<CommonImagePickTextFeild> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: widget.buttonHeight ?? 48.h,
          alignment: Alignment.center,
          // decoration: BoxDecoration(
          //   border: Border.all(color: widget.borderColor ?? appConstants.primary6Color),
          //   borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.r),
          // ),
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: InkWell(
                  splashFactory: NoSplash.splashFactory,
                  onTap: () async {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                      currentFocus.focusedChild?.unfocus();
                    }

                    await commonImagePickerBottomSheet(
                      context: context,
                      heightFactor: widget.heightFactor,
                      onImageSelect: widget.onImageSelect,
                      isMultipleImagePick: widget.isMultipleImagePick,
                    );
                  },
                  child: CommonWidget.container(
                    borderRadius: 5.r,
                    color: appConstants.primary6Color,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    child: CommonWidget.commonText(
                      text: "Browse",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.body2RegularHeading.copyWith(),
                    ),
                  ),
                ),
              ),
              CommonWidget.sizedBox(width: 5),
              Expanded(
                flex: 5,
                child: InkWell(
                  splashFactory: NoSplash.splashFactory,
                  onTap: () async {
                    // FocusScopeNode currentFocus = FocusScope.of(context);
                    // if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                    //   currentFocus.focusedChild?.unfocus();
                    // }

                    // if (widget.onTextTap != null) {
                    //   widget.onTextTap!.call();
                    // }
                    // if (widget.pathToDisplay != null && widget.pathToDisplay != "" && widget.showImageDialog != false) {
                    //   await CommonWidget.commonImageDialog(path: widget.pathToDisplay.toString(), context: context);
                    // } else if (pickImageCubit.imageList.length == 1 && widget.showImageDialog != false) {
                    //   await CommonWidget.commonImageDialog(
                    //     path: pickImageCubit.imageList.first.path,
                    //     context: context,
                    //   );
                    // } else {
                    //   await commonImagePickerBottomSheet(
                    //     context: context,
                    //     heightFactor: widget.heightFactor,
                    //     onImageSelect: widget.onImageSelect,
                    //     isMultipleImagePick: widget.isMultipleImagePick,
                    //   );
                    // }
                  },
                  child: CommonWidget.commonText(
                    textAlign: TextAlign.left,
                    text: widget.showImageDialog != false
                        ? checkImageType()
                        : TranslationConstants.choose_file.translate(context),
                    style: Theme.of(context).textTheme.body2RegularHeading.copyWith(
                          color: appConstants.neutral1Color,
                        ),
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // CommonRouter.pushNamed(RouteList.catalogue_screen, arguments: pickImageCubit);
                },
                child: CommonWidget.container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3),
                  color: appConstants.neutral10Color,
                  borderRadius: 5.r,
                  child: CommonWidget.commonText(
                    text: "edit",
                    fontSize: 13.5,
                    color: appConstants.whiteBackgroundColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Visibility(
        //   visible: widget.isShowImag ?? true,
        //   child: widget.isMultipleImagePick && pickImageCubit.imageList.isNotEmpty
        //       ? CommonWidget.sizedBox(
        //           height: 100,
        //           child: ListView.builder(
        //             scrollDirection: Axis.horizontal,
        //             itemCount: pickImageCubit.imageList.length,
        //             itemBuilder: (context, index) {
        //               return Padding(
        //                 padding: EdgeInsets.symmetric(horizontal: 5.w),
        //                 child: Container(
        //                   width: 100.w,
        //                   height: 100.h,
        //                   decoration: BoxDecoration(
        //                     borderRadius: BorderRadius.circular(7.r),
        //                     image: DecorationImage(
        //                       image: MemoryImage(pickImageCubit.imageList[index].bytes),
        //                       fit: BoxFit.cover,
        //                     ),
        //                   ),
        //                   child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       InkWell(
        //                         onTap: () async {
        //                           ImageCropArgs cropArgs = ImageCropArgs(
        //                             imagePathOrURL: pickImageCubit.imageList[index].path,
        //                             aspectRatio: 0,
        //                           );
        //                           Uint8List bytes =
        //                               await CommonRouter.pushNamed(RouteList.image_crop_screen, arguments: cropArgs)
        //                                   as Uint8List;
        //                           pickImageCubit.cropedImage(bytes: bytes, index: index);
        //                         },
        //                         child: ClipRRect(
        //                           borderRadius: BorderRadius.only(
        //                             topLeft: Radius.circular(7.r),
        //                             bottomRight: Radius.circular(15.r),
        //                           ),
        //                           child: CommonWidget.container(
        //                             height: 27,
        //                             width: 25,
        //                             color: appConstants.secondary1Color,
        //                             alignment: Alignment.center,
        //                             child: CommonWidget.imageBuilder(
        //                               image: "assets/svgs/common/edit_pen.svg",
        //                               height: 15.h,
        //                               color: appConstants.whiteBackgroundColor,
        //                             ),
        //                           ),
        //                         ),
        //                       ),
        //                       InkWell(
        //                         onTap: () => pickImageCubit.removeData(index: index),
        //                         child: CommonWidget.container(
        //                           height: 27,
        //                           width: 25,
        //                           color: appConstants.secondary1Color,
        //                           isBorderOnlySide: true,
        //                           bottomLeft: 15.r,
        //                           topRight: 7.r,
        //                           alignment: Alignment.center,
        //                           child: CommonWidget.imageBuilder(
        //                             image: "assets/svgs/common/close_icon-1.svg",
        //                             height: 20.h,
        //                             color: appConstants.whiteBackgroundColor,
        //                           ),
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               );
        //             },
        //           ),
        //         )
        //       : const SizedBox.shrink(),
        // ),
      ],
    );
  }

  String checkImageType() {
    if (!widget.isMultipleImagePick && widget.pathToDisplay != null && widget.pathToDisplay != "") {
      return TranslationConstants.show_selected_image.translate(context);
    } else if (widget.isMultipleImagePick) {
      return TranslationConstants.show_selected_image.translate(context);
    } else if (!widget.isMultipleImagePick) {
      return TranslationConstants.show_selected_image.translate(context);
    }
    return TranslationConstants.choose_file.translate(context);
  }
}

Future<XFile?> commonImagePickerBottomSheet({
  required BuildContext context,
  required bool isMultipleImagePick,
  VoidCallback? onImageSelect,
  double? heightFactor,
}) async {
  var data = await CommonWidget.openBottomBar(
    context: context,
    heightFactor: heightFactor ?? 0.22.h,
    isTitleBar: true,
    dividerColor: appConstants.neutral1Color,
    title: TranslationConstants.uploadImg.translate(context),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CommonWidget.imageButton(
                svgPicturePath: "assets/svgs/common/camera.svg",
                color: appConstants.primary1Color,
                iconSize: 25.r,
                onTap: () async {
                  if (isMultipleImagePick) {
                    XFile? list = await ImagePicker().pickImage(source: ImageSource.camera);
                    // pickImageCubit.pickMultiImage(pickType: "camara", onImageSelect: onImageSelect);
                    CommonRouter.pop(args: list);
                  } else {
                    XFile? list = await ImagePicker().pickImage(source: ImageSource.camera);
                    // pickImageCubit.pickMultiImage(pickType: "camara", onImageSelect: onImageSelect);
                    CommonRouter.pop(args: list);
                  }
                },
              ),
              CommonWidget.sizedBox(height: 10),
              CommonWidget.commonText(
                text: TranslationConstants.camera.translate(context),
                style: Theme.of(context).textTheme.caption2MediumHeading.copyWith(color: appConstants.neutral1Color),
              ),
            ],
          ),
          CommonWidget.sizedBox(width: 25),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CommonWidget.imageButton(
                svgPicturePath: "assets/svgs/common/gallery.svg",
                color: appConstants.primary1Color,
                iconSize: 25.r,
                onTap: () async {
                  if (isMultipleImagePick) {
                    XFile? list = await ImagePicker().pickImage(source: ImageSource.gallery);
                    // pickImageCubit.pickMultiImage(pickType: "camara", onImageSelect: onImageSelect);
                    CommonRouter.pop(args: list);
                  } else {
                    XFile? list = await ImagePicker().pickImage(source: ImageSource.gallery);

                    // pickImageCubit.pickImage(pickType: "gallery", context: context, onImageSelect: onImageSelect);
                    CommonRouter.pop(args: list);
                  }
                },
              ),
              CommonWidget.sizedBox(height: 10),
              CommonWidget.commonText(
                text: TranslationConstants.gallery.translate(context),
                style: Theme.of(context).textTheme.caption2MediumHeading.copyWith(color: appConstants.neutral1Color),
              ),
            ],
          ),
        ],
      ),
    ),
  );
  if (data is XFile) {
    return data;
  }
  return null;
}
