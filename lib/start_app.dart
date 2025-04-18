import 'dart:developer';
import 'dart:io';
import 'package:catcher_2/core/catcher_2.dart';
import 'package:catcher_2/utils/catcher_2_error_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_project/common/constants/languages.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_project/core/network/network_connection.dart';
import 'package:flutter_project/presentation/provider/app_provider/language_provider.dart';
import 'package:flutter_project/presentation/provider/common_provider/theme_provider.dart';
import 'package:flutter_project/common/constants/route_constants.dart';
import 'package:flutter_project/common/constants/theme.dart';
import 'package:flutter_project/core/localization/app_localizations.dart';
import 'package:flutter_project/core/navigation/fade_page_route_builder.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/journeys/common_screen/loading_screen.dart';
import 'package:flutter_project/core/navigation/routes.dart';
import 'package:flutter_project/presentation/utils/app_functions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DeviceType { phone, tablet }

class StartApp extends StatefulWidget {
  const StartApp({super.key});

  @override
  State<StartApp> createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {
  final _materialAppKey = GlobalKey();
  late ThemeProvider _themeProvider;

  @override
  void initState() {
    appConstants.loadLight();
    super.initState();
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    // badgeCounterProvider = Provider.of<CounterProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _themeProvider.loadPreferredTheme();
      loadInitialData();
      _configureSelectNotificationSubject();
      logicOfIntroductionScreen();
      getPreviousNotificationCount();
      internetCheck();
      initialization();
    });
  }

  void loadInitialData() {
    // _accountInfoCubit.loadInitialData();
  }

  @override
  void dispose() {
    _themeProvider.dispose();
    // badgeCounterProvider?.dispose();
    super.dispose();
  }

  Future<void> getPreviousNotificationCount() async {
    totalNotificationCounts = await AppFunctions().getNotificationCount();
  }

// splash remove
  void initialization() async {
    await Future.delayed(const Duration(seconds: 3));
  }

  void internetCheck() {
    if (Platform.isAndroid) {
      listenConnection();
    }
  }

  void _configureSelectNotificationSubject() {
    try {
      Future.delayed(
        Duration.zero,
        () {
          if (rootContext != null) {
            listenNotificationStream();

            // listenDeepLinkStream();
          }
        },
      );
    } catch (e) {
      Future.delayed(
        Duration.zero,
        () async {
          if (rootContext != null) {
            if (userToken == null) {
              await AppFunctions().forceLogout();
            } else {
              if (rootContext == null) return;
              Navigator.of(rootContext!).pushReplacementNamed(RouteList.app_home);
            }
          }
        },
      );
    }
  }

  void listenNotificationStream() {
    // try {
    //   final selectedNotificationProvider = Provider.of<SelectedNotificationProvider>(context, listen: false);

    //   selectedNotificationProvider.addListener(
    //     () async {
    //       final model = selectedNotificationProvider.getPayloadModel;

    //       if (model != null) {
    //         //(userEntity != null);
    //         // AppFunctions().decrementNotificationCount();
    //         if (userEntity == null) {
    //           if (currentRouteName == RouteList.initial) {
    //             await AppFunctions().forceLogout();
    //           }
    //         } else if (userEntity != null && model.type == 'Combo Product Offer') {
    //           // TODO notification Naviagting hendel
    //           // if (event.payloadModel?.comnoProductId != '') {
    //           //   await Catcher2.navigatorKey?.currentState?.pushNamed(
    //           //     RouteList.single_combo_details_screen,
    //           //     arguments: SingleComboScreenArgs(
    //           //       comboId: int.tryParse(event.payloadModel?.comnoProductId ?? '0') ?? 0,
    //           //       isComeInCart: false,
    //           //     ),
    //           //   );
    //           // }
    //         }
    //       }
    //     },
    //   );
    // } catch (e) {
    //   if (kDebugMode) {
    //     print(e);
    //   }
    // }
  }

  DeviceType getDeviceType() {
    final data = MediaQueryData.fromView(View.of(context));
    return data.size.shortestSide < 550 ? DeviceType.phone : DeviceType.tablet;
  }

  int counter = 0;
  logicOfIntroductionScreen() async {
    final prefs = await SharedPreferences.getInstance();
    counter = prefs.getInt('counter') ?? 0;
  }

  BuildContext? rootContext;

  @override
  Widget build(BuildContext context) {
    rootContext = context;

    if (kDebugMode && 1 != 1) {
      debugInvertOversizedImages = true;
    }

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final theme = currentTheme;
        if (Platform.isAndroid) {
          // Optional UI adjustments for Android
        } else if (Platform.isIOS) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: theme == Themes.dark ? appConstants.primary1Color : appConstants.primary1Color,
            statusBarIconBrightness: theme == Themes.dark ? Brightness.light : Brightness.dark,
            statusBarBrightness: theme == Themes.dark ? Brightness.light : Brightness.dark,
          ));
        }

        return Material(
          child: Consumer<LanguageProvider>(
            builder: (context, languageProvider, _) {
              return ScreenUtilInit(
                useInheritedMediaQuery: true,
                designSize: getDeviceType() == DeviceType.tablet ? const Size(834, 1194) : const Size(360, 800),
                rebuildFactor: (old, data) => RebuildFactors.orientation(old, data),
                splitScreenMode: true,
                minTextAdapt: true,
                builder: (context, snapshot) {
                  return MaterialApp(
                    key: _materialAppKey,
                    debugShowCheckedModeBanner: false,
                    locale: Locale(currentLangCode),
                    supportedLocales: languagesList.map((e) => Locale(e.shortCode.toString())).toList(),
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    themeMode: theme == Themes.dark ? ThemeMode.dark : ThemeMode.light,
                    scaffoldMessengerKey: snackbarKey,
                    navigatorKey: Catcher2.navigatorKey,
                    navigatorObservers: <NavigatorObserver>[
                      // AnalyticsService.getAnalyticsObserver(), //Firebase Analytics
                      // MyRouteObserver(), //User Screen Time Coutner and Analytics
                    ],
                    theme: ThemeData(
                      fontFamily: 'Poppins',
                      useMaterial3: true,
                      dialogBackgroundColor: appConstants.grey1,
                      scaffoldBackgroundColor: appConstants.whiteBackgroundColor,
                      primaryColor: appConstants.primary1Color,
                      textSelectionTheme: TextSelectionThemeData(
                        selectionHandleColor: Colors.transparent,
                        selectionColor: appConstants.primary1Color.withValues(alpha: 0.3),
                        cursorColor: appConstants.primary1Color,
                      ),
                      highlightColor: Colors.transparent,
                      colorScheme: ColorScheme.fromSeed(
                        seedColor: Colors.transparent,
                        // background: appConstants.greyBackgroundColor,
                      ),
                    ),
                    builder: (BuildContext context, Widget? child) {
                      ErrorWidget.builder = (details) => Material(
                            child: Catcher2ErrorWidget(
                              details: details,
                              showStacktrace: true,
                              title: "An application error has occurred",
                              description:
                                  "There was unexpected situation in application. Application has been ' 'able to recover from error state,Please send screenshot to support team",
                              maxWidthForSmallMode: 150,
                            ),
                          );

                      return LoadingScreen(screen: child ?? Container());
                    },
                    initialRoute: RouteList.initial,
                    onGenerateRoute: (RouteSettings settings) {
                      if (kDebugMode) {
                        log("Routes : ${settings.name}");
                      }
                      final routes = Routes.getRoutes(settings);
                      final WidgetBuilder? builder = routes[settings.name];
                      return FadePageRouteBuilder(builder: builder!, settings: settings);
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
