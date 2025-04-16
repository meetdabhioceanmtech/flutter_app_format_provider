import 'package:flutter/material.dart';
import 'package:flutter_project/common/constants/translation_constants.dart';
import 'package:flutter_project/common/extention/size_box_extension.dart';
import 'package:flutter_project/common/extention/string_extension.dart';
import 'package:flutter_project/common/extention/theme_extension.dart';
import 'package:flutter_project/domain/entities/language/app_language/app_language_entity.dart';
import 'package:flutter_project/presentation/provider/app_language/app_language_provider.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/journeys/screens/select_language/language_screen.dart';
import 'package:flutter_project/presentation/widgets/common_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

abstract class LanguageWidget extends State<LanguageScreen> {
  Widget languageLoadedView({required BuildContext context}) {
    return Consumer<AppLanguageProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            10.sHeight,
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: provider.languageEntity.length,
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 3.0.r,
                ),
                itemBuilder: (context, index) {
                  AppLanguageEntity appLanguageEntity = provider.languageEntity[index];
                  return languageContainer(
                    provider: provider,
                    index: index,
                    appLanguageEntity: appLanguageEntity,
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 15.w),
              child: CommonWidget.commonButton(
                alignment: Alignment.center,
                borderRadius: 8.r,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                context: context,
                text: TranslationConstants.submit.translate(context),
                style: Theme.of(context).textTheme.body1MediumHeading.copyWith(
                      color: appConstants.whiteBackgroundColor,
                    ),
                onTap: () async {
                  await provider.setLocallyLanguage(index: provider.selectIndex);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget languageContainer({
    required AppLanguageProvider provider,
    required int index,
    required AppLanguageEntity appLanguageEntity,
  }) {
    bool isSelected = provider.selectedLanguage == appLanguageEntity.shortCode;
    return GestureDetector(
      onTap: () async {
        await provider.loadLanguageLabels(
          selectedIndex: index,
          appLanguageEntity: appLanguageEntity,
        );
      },
      child: CommonWidget.container(
        borderRadius: 8.r,
        color: isSelected ? appConstants.secondary4Color : appConstants.primary1Color,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: CommonWidget.container(
          height: 60,
          width: 158,
          borderRadius: 7.r,
          color: isSelected ? appConstants.primary1Color : appConstants.grayBackgroundColor,
          child: Center(
            child: CommonWidget.commonText(
              text: appLanguageEntity.title,
              style: Theme.of(context).textTheme.body1MediumHeading.copyWith(
                    color: isSelected ? appConstants.whiteBackgroundColor : appConstants.neutral1Color,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
