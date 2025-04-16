import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/common/constants/common_router.dart';
import 'package:flutter_project/common/constants/route_constants.dart';
import 'package:flutter_project/common/constants/theme.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/journeys/screens/image_crop/image_crop_args.dart';
import 'package:flutter_project/presentation/journeys/screens/privacy_and_terms/privacy_and_terms_screen.dart';
import 'package:flutter_project/presentation/provider/theme/theme_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_project/common/constants/translation_constants.dart';
import 'package:flutter_project/common/extention/size_box_extension.dart';
import 'package:flutter_project/common/extention/string_extension.dart';
import 'package:flutter_project/common/extention/theme_extension.dart';
import 'package:flutter_project/presentation/provider/toggle/toggle_provider.dart';
import 'package:flutter_project/presentation/widgets/common_widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: CommonWidget.padding(
            horizontal: 15,
            vertical: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: CommonWidget.imageBuilder(
                    image: "assets/svgs/common/login_image.svg",
                    height: 170.h,
                  ),
                ),
                30.sHeight,
                CommonWidget.commonText(
                  text: TranslationConstants.login.translate(context),
                  style: Theme.of(context).textTheme.h6BoldHeading.copyWith(
                        color: appConstants.primary1Color,
                      ),
                ),
                8.sHeight,
                CommonWidget.commonText(
                  text: TranslationConstants.job_search_helps_you_hire_staff_in_2_days.translate(context),
                  maxLines: 2,
                  style: Theme.of(context).textTheme.body2MediumHeading.copyWith(
                        color: appConstants.primary1Color,
                      ),
                ),
                30.sHeight,
                Form(
                  key: loginKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonWidget.field(
                        context: context,
                        controller: emailController,
                        fieldTitle: TranslationConstants.email_address.translate(context),
                        textInputType: TextInputType.emailAddress,
                        hintText: TranslationConstants.enter_email_address.translate(context),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return TranslationConstants.please_enter_your_email_id.translate(context);
                          } else if (!value.trim().isValidEmail()) {
                            return TranslationConstants.please_enter_valid_email_id.translate(context);
                          }
                          return null;
                        },
                      ),
                      Consumer<ToggleProvider>(
                        builder: (context, toggleProvider, child) {
                          return CommonWidget.field(
                            context: context,
                            controller: passwordController,
                            fieldTitle: TranslationConstants.password.translate(context),
                            textInputType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.send,
                            obscureText: toggleProvider.value,
                            hintText: TranslationConstants.enter_your_password.translate(context),
                            suffixWidget: IconButton(
                              highlightColor: Colors.transparent,
                              onPressed: () => toggleProvider.setValue(value: !toggleProvider.value),
                              icon: Icon(toggleProvider.value ? Icons.visibility_off : Icons.visibility),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return TranslationConstants.please_enter_your_password.translate(context);
                              } else if (value.length < 6) {
                                return TranslationConstants.password_must_be_at_least_6_characters_long
                                    .translate(context);
                              }

                              return null;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                10.sHeight,
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    // onTap: () async => await CommonRouter.pushNamed(RouteList.forgot_screen),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: CommonWidget.commonText(
                      textAlign: TextAlign.center,
                      text: TranslationConstants.forgot_password_question.translate(context),
                      color: appConstants.primary1Color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                25.sHeight,
                CommonWidget.commonButton(
                  text: TranslationConstants.login.translate(context),
                  context: context,
                  onTap: () async => await CommonRouter.pushNamed(RouteList.privacy_and_terms_screen),
                ),
                20.sHeight,
                InkWell(
                  onTap: () async => await CommonRouter.pushNamed(RouteList.notification_screen),
                  child: CommonWidget.commonText(
                    text: 1 == 1 ? "Notification Screen" : TranslationConstants.sign_up.translate(context),
                    style: Theme.of(context).textTheme.body2SemiboldHeading.copyWith(
                          color: appConstants.primary1Color,
                        ),
                  ),
                ),
                20.sHeight,
                InkWell(
                  onTap: () async {
                    ImageCropArgs cropArgs = ImageCropArgs(
                      imagePathOrURL:
                          'https://gratisography.com/wp-content/uploads/2025/03/gratisography-vintage-robot-1036x780.jpg',
                      aspectRatio: 0,
                    );
                    await CommonRouter.pushNamed(RouteList.image_crop_screen, arguments: cropArgs);
                  },
                  child: CommonWidget.commonText(
                    text: 1 == 1 ? "Image Crop Screen" : TranslationConstants.sign_up.translate(context),
                    style: Theme.of(context).textTheme.body2SemiboldHeading.copyWith(
                          color: appConstants.primary1Color,
                        ),
                  ),
                ),
                20.sHeight,
                InkWell(
                  onTap: () async => await CommonRouter.pushNamed(
                    RouteList.privacy_and_terms_screen,
                    arguments: TypeScreen.PRIVACY_CONDITION,
                  ),
                  child: CommonWidget.commonText(
                    text: 1 == 1 ? "Privacy And Terms Screen" : TranslationConstants.sign_up.translate(context),
                    style: Theme.of(context).textTheme.body2SemiboldHeading.copyWith(
                          color: appConstants.primary1Color,
                        ),
                  ),
                ),
                20.sHeight,
                InkWell(
                  onTap: () async => await CommonRouter.pushNamed(RouteList.language_screen),
                  child: CommonWidget.commonText(
                    text: 1 == 1 ? "Language Screen" : TranslationConstants.sign_up.translate(context),
                    style: Theme.of(context).textTheme.body2SemiboldHeading.copyWith(
                          color: appConstants.primary1Color,
                        ),
                  ),
                ),
                20.sHeight,
                InkWell(
                  onTap: () => FirebaseCrashlytics.instance.crash(),
                  child: CommonWidget.commonText(
                    text: 'FirebaseCrashlytics Test',
                    style: Theme.of(context).textTheme.body2SemiboldHeading.copyWith(
                          color: appConstants.primary1Color,
                        ),
                  ),
                ),
                20.sHeight,
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        Provider.of<ThemeProvider>(context, listen: false).toggleTheme(Themes.system);
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          "System Default",
                          style: Theme.of(context).textTheme.body2BoldHeading.copyWith(fontSize: 20.sp),
                        ),
                        trailing: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, color: appConstants.primary1Color),
                          padding: EdgeInsets.all(2.5.r),
                          child: Container(
                            height: 20.r,
                            width: 20.r,
                            decoration: BoxDecoration(
                              color: currentTheme == Themes.system
                                  ? appConstants.primary1Color
                                  : appConstants.secondary1Color,
                              shape: BoxShape.circle,
                              border: Border.all(color: appConstants.whiteBackgroundColor, width: 2.5.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Provider.of<ThemeProvider>(context, listen: false).toggleTheme(Themes.light);
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Light Mode',
                          style: Theme.of(context).textTheme.body2BoldHeading.copyWith(fontSize: 20.sp),
                        ),
                        trailing: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, color: appConstants.primary1Color),
                          padding: EdgeInsets.all(2.5.r),
                          child: Container(
                            height: 20.r,
                            width: 20.r,
                            decoration: BoxDecoration(
                              color: (currentTheme == Themes.light)
                                  ? appConstants.primary1Color
                                  : appConstants.secondary1Color,
                              shape: BoxShape.circle,
                              border: Border.all(color: appConstants.whiteBackgroundColor, width: 2.5.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Provider.of<ThemeProvider>(context, listen: false).toggleTheme(Themes.dark);
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Dark Mode',
                          style: Theme.of(context).textTheme.body2BoldHeading.copyWith(fontSize: 20.sp),
                        ),
                        trailing: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, color: appConstants.primary1Color),
                          padding: EdgeInsets.all(2.5.r),
                          child: Container(
                            height: 20.r,
                            width: 20.r,
                            decoration: BoxDecoration(
                              color: (currentTheme == Themes.dark)
                                  ? appConstants.primary1Color
                                  : appConstants.secondary1Color,
                              shape: BoxShape.circle,
                              border: Border.all(color: appConstants.whiteBackgroundColor, width: 2.5.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                20.sHeight,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
