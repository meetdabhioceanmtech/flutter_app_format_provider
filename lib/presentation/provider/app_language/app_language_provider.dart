import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_project/common/constants/env_constants.dart';
import 'package:flutter_project/common/constants/hive_constants.dart';
import 'package:flutter_project/common/constants/languages.dart';
import 'package:flutter_project/data/core/api_constants.dart';
import 'package:flutter_project/data/datasources/common_api_call.dart';
import 'package:flutter_project/data/models/common_respnse_model.dart';
import 'package:flutter_project/data/models/language_model.dart';
import 'package:flutter_project/data/models/model_response_extend.dart';
import 'package:flutter_project/domain/entities/app_error.dart';
import 'package:flutter_project/domain/entities/language/app_language/app_language_entity.dart';
import 'package:flutter_project/domain/usecases/api_usecase.dart';
import 'package:flutter_project/presentation/provider/loading/loading_provider.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/utils/app_functions.dart';

class AppLanguageProvider extends ChangeNotifier {
  late ApiUsecase _apiUsecase;

  final LoadingProvider loadingProvider;

  bool isLoading = false;
  String? errorMessage;
  AppErrorType? errorType;

  int selectIndex = 0;
  List<AppLanguageEntity> languageEntity = [];
  List<AppLanguageEntity> originalLanguageList = [];
  String selectedLanguage = 'en';

  AppLanguageProvider({
    required this.loadingProvider,
    required ApiUsecase apiUsecase,
  }) : _apiUsecase = apiUsecase;

  void updateUsecase(ApiUsecase usecase) {
    _apiUsecase = usecase;
  }

  Future<void> loadInitialData<T extends ModelResponseExtend>() async {
    final endpoint = dotenv.env[EnvConstants.API_ENDPOINT_2];
    if (endpoint == null) return;

    isLoading = true;
    notifyListeners();

    Either<AppError, T> response = await _apiUsecase.call(
      endpoint: endpoint,
      fromJson: (json) => LanguageModel.fromJson(json) as T,
      apiCallType: APICallType.GET,
      screenName: 'AppLanguage',
    );
    response.fold(
      (error) async {
        loadingProvider.hide();
        if (error.errorType == AppErrorType.unauthorised) {
          await AppFunctions().forceLogout();
        }

        isLoading = false;
        errorMessage = error.message;
        errorType = error.errorType;
        notifyListeners();
      },
      (appLangList) async {
        if (appLangList is LanguageModel) {
          loadingProvider.hide();

          int defaultIndex = 0;
          String code = "en";

          if (languages.isNotEmpty) {
            final index = languages.indexWhere((e) => e.isDefault == 1);
            if (index != -1) {
              code = languages[index].shortCode;
            }
          }

          List<AppLanguageEntity> temp = [...?appLangList.data];

          if (temp.isEmpty) {
            isLoading = false;
            errorMessage = "No languages found.";
            notifyListeners();
            return;
          }

          final enIndex = temp.indexWhere((e) => e.shortCode == code);
          if (enIndex != -1) {
            defaultIndex = enIndex;
          }

          temp = temp.map((e) => e.copyWith(isDefault: 0)).toList();

          if (defaultIndex >= 0 && defaultIndex < temp.length) {
            temp[defaultIndex] = temp[defaultIndex].copyWith(isDefault: 1);
          }

          languages = temp;
          currentLangCode = code;

          await currentLanBox.put(HiveConstants.PREFERRED_LANGUAGE, currentLangCode);
          await currentLanBox.put(HiveConstants.APP_LANGUAGE_LIST, languages);

          languageEntity = temp;
          originalLanguageList = temp;
          selectIndex = defaultIndex;
          selectedLanguage = code;
          isLoading = false;
          notifyListeners();

          // await loadLanguageLabels(
          //   appLanguageEntity: temp[defaultIndex],
          //   selectedIndex: defaultIndex,
          // );
        }
      },
    );
  }

  Future<void> loadLanguageLabels<T extends ModelResponseExtend>({
    required int selectedIndex,
    required AppLanguageEntity appLanguageEntity,
  }) async {
    final endpoint = dotenv.env[EnvConstants.API_ENDPOINT_3];
    if (endpoint == null) return;

    isLoading = true;
    notifyListeners();

    Either<AppError, T> response = await _apiUsecase.call(
      endpoint: '$endpoint${appLanguageEntity.id}?/salt=${ApiConstatnts.salt}',
      fromJson: (json) => CommonResponseModel.fromJson(json) as T,
      apiCallType: APICallType.GET,
      screenName: 'AppLanguage',
    );

    await response.fold(
      (error) async {
        if (error.errorType == AppErrorType.unauthorised) {
          await AppFunctions().forceLogout();
        }

        loadingProvider.hide();
        errorMessage = error.message;
        errorType = error.errorType;
        isLoading = false;
        notifyListeners();
      },
      (status) async {
        loadingProvider.hide();
        isLoading = false;

        if (status is CommonResponseModel && status.status) {
          if (status.data.isNotEmpty) {
            String code = appLanguageEntity.shortCode;
            final file = await File('$languageLocalPath/$code.json').create(recursive: true);
            file.writeAsStringSync(jsonEncode(status.data));
          }

          languageEntity = languageEntity.map((e) => e.copyWith(isDefault: 0)).toList();
          languageEntity[selectedIndex] = languageEntity[selectedIndex].copyWith(isDefault: 1);
          originalLanguageList = List.from(languageEntity);
          selectIndex = selectedIndex;
          selectedLanguage = languageEntity[selectedIndex].shortCode;
          notifyListeners();
        }
      },
    );
  }

  Future<void> setLocallyLanguage({required int index}) async {
    languages = languages.map((e) => e.copyWith(isDefault: 0)).toList();
    languages[index] = languages[index].copyWith(isDefault: 1);
    await currentLanBox.put(HiveConstants.PREFERRED_LANGUAGE, languages[index].shortCode);
    await appLanBox.put(HiveConstants.APP_LANGUAGE_LIST, languages);
    selectedLanguage = languages[index].shortCode;
    notifyListeners();
  }
}
