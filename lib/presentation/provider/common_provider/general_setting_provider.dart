import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_project/common/constants/env_constants.dart';
import 'package:flutter_project/common/constants/hive_constants.dart';
import 'package:flutter_project/data/datasources/common_api_call.dart';
import 'package:flutter_project/data/models/app_model/general_setting_model.dart';
import 'package:flutter_project/data/models/common_model/model_response_extend.dart';
import 'package:flutter_project/domain/entities/app_error.dart';
import 'package:flutter_project/domain/usecases/api_usecase.dart';
import 'package:flutter_project/presentation/custom_snackbar.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/utils/app_functions.dart';

class GeneralSettingProvider extends ChangeNotifier {
  late ApiUsecase _apiUsecase;
  GeneralSettingProvider();

  void updateUsecase(ApiUsecase usecase) {
    _apiUsecase = usecase;
  }

  Future<void> getGeneralSetting<T extends ModelResponseExtend>() async {
    final endpoint = dotenv.env[EnvConstants.API_ENDPOINT_1];
    if (endpoint == null) return;

    Either<AppError, T> response = await _apiUsecase.call(
      endpoint: endpoint,
      fromJson: (json) => GeneralSettingModel.fromJson(json) as T,
      apiCallType: APICallType.GET,
      screenName: 'getGeneralSetting',
      header: {"Accept": "application/json"},
    );

    response.fold(
      (error) async {
        if (error.errorType == AppErrorType.unauthorised) {
          await AppFunctions().forceLogout();
          return error.message;
        }

        CustomSnackbar.show(snackbarType: SnackbarType.ERROR, message: error.message);
      },
      (data) async {
        if (data is GeneralSettingModel) {
          await generalSettingBox.put(HiveConstants.GENERAL_SETTING_DATA, data.data);
          generalSettingEntity = await generalSettingBox.get(HiveConstants.GENERAL_SETTING_DATA);

          debugPrint('getGeneralSetting API success ==> ${data.data}');

          notifyListeners();
        }
      },
    );
  }
}
