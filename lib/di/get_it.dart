// import 'package:get_it/get_it.dart';
// import 'package:http/http.dart';
// import 'package:flutter_project/data/datasources/language_local_data_source.dart';
// import 'package:flutter_project/data/repositories/app_repository.dart';
// import 'package:flutter_project/data/repositories/app_repository_impl.dart';
// import 'package:flutter_project/domain/usecases/get_preferred_language.dart';
// import 'package:flutter_project/domain/usecases/update_language.dart';
// import 'package:flutter_project/presentation/provider/app_language/app_language_provider.dart';
// import 'package:flutter_project/presentation/provider/bottom_navigation/bottom_navigation_provider.dart';
// import 'package:flutter_project/presentation/provider/counter/counter_provider.dart';
// import 'package:flutter_project/presentation/provider/general_setting/general_setting_provider.dart';
// import 'package:flutter_project/presentation/provider/language/language_provider.dart';
// import 'package:flutter_project/presentation/provider/loading/loading_provider.dart';
// import 'package:flutter_project/presentation/provider/notification/notification_handle/notification_provider.dart';
// import 'package:flutter_project/presentation/provider/notification/selected_notification/selected_notification_provider.dart';
// import 'package:flutter_project/presentation/provider/terms_condition/terms_condition_provider.dart';
// import 'package:flutter_project/presentation/provider/theme/theme_provider.dart';
// import 'package:flutter_project/presentation/provider/toggle/toggle_provider.dart';
// import 'package:flutter_project/data/core/api_client.dart';
// import 'package:flutter_project/data/datasources/api_data_source.dart';
// import 'package:flutter_project/data/repositories/api_data_repositorie_impl.dart';
// import 'package:flutter_project/domain/repositories/api_repositorie.dart';
// import 'package:flutter_project/domain/usecases/api_usecase.dart';

// final getItInstance = GetIt.I;

// Future init() async {
//   getItInstance.registerLazySingleton<Client>(() => Client());
//   getItInstance.registerLazySingleton<ApiClient>(() => ApiClient(getItInstance()));

//   // Analytics Property
//   // getItInstance.registerLazySingleton<AnalyticsService>(() => AnalyticsService());

//   //Data source Dependency
//   getItInstance.registerLazySingleton<ApiDataSource>(() => ApiDataSourceImpl(client: getItInstance()));

//   //Data Repository Dependency
//   getItInstance.registerLazySingleton<ApiDataRepositories>(() => ApiDataRepositoriesImpl(dataSource: getItInstance()));

//   //Usecase Dependency
//   getItInstance.registerLazySingleton<ApiUsecase>(() => ApiUsecase(dataRepositories: getItInstance()));

//   //Bloc Dependency

//   //Provider Dependency
//   getItInstance.registerFactory<SelectedNotificationProvider>(() => SelectedNotificationProvider());
//   getItInstance.registerFactory<ToggleProvider>(() => ToggleProvider());
//   getItInstance.registerFactory<CounterProvider>(() => CounterProvider());
//   getItInstance.registerFactory<GeneralSettingProvider>(() => GeneralSettingProvider(apiUsecase: getItInstance()));
//   // register cubit register

//   getItInstance.registerFactory<TermsConditionProvider>(
//       () => TermsConditionProvider(apiUsecase: getItInstance(), loadingProvider: getItInstance()));
//   getItInstance.registerFactory<AppLanguageProvider>(
//       () => AppLanguageProvider(apiUsecase: getItInstance(), loadingProvider: getItInstance()));

//   // Theme Dependency
//   getItInstance.registerFactory(() => BottomNavigationProvider());
//   getItInstance.registerSingleton<LoadingProvider>(LoadingProvider());
//   getItInstance.registerSingleton<ThemeProvider>(ThemeProvider());

//   // Language
//   getItInstance.registerFactory<LanguageProvider>(
//       () => LanguageProvider(getPreferredLanguage: getItInstance(), updateLanguage: getItInstance()));
//   getItInstance.registerLazySingleton<LanguageLocalDataSource>(() => LanguageLocalDataSourceImpl());
//   getItInstance.registerLazySingleton<AppRepository>(() => AppRepositoryImpl(languageLocalDataSource: getItInstance()));
//   getItInstance.registerLazySingleton<GetPreferredLanguage>(() => GetPreferredLanguage(appRepository: getItInstance()));
//   getItInstance.registerLazySingleton<UpdateLanguage>(() => UpdateLanguage(appRepository: getItInstance()));
//   getItInstance.registerFactory<NotificationProvider>(
//       () => NotificationProvider(loadingProvider: getItInstance(), apiUsecase: getItInstance()));
// }
