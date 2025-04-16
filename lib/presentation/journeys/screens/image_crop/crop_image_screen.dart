import 'package:flutter/material.dart';
import 'package:flutter_project/common/constants/translation_constants.dart';
import 'package:flutter_project/common/extention/string_extension.dart';
import 'package:flutter_project/common/extention/theme_extension.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/journeys/screens/image_crop/crop_image_widget.dart';
import 'package:flutter_project/presentation/journeys/screens/image_crop/image_crop_args.dart';
import 'package:flutter_project/presentation/widgets/common_widget.dart';

class CropImageScreen extends StatefulWidget {
  final ImageCropArgs cropArgs;

  const CropImageScreen({super.key, required this.cropArgs});

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends CropImageWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appConstants.whiteBackgroundColor,
      appBar: AppBar(
        title: CommonWidget.commonText(
          text: TranslationConstants.crop_image.translate(context),
          style: Theme.of(context).textTheme.body1BoldHeading.copyWith(color: appConstants.whiteBackgroundColor),
        ),
        iconTheme: IconThemeData(color: appConstants.whiteBackgroundColor),
        backgroundColor: appConstants.primary1Color,
        centerTitle: true,
      ),
      body: Container(
        color: appConstants.whiteBackgroundColor,
        child: Center(child: buildImage()),
      ),
      bottomNavigationBar: buildButtons(),
    );
  }
}
