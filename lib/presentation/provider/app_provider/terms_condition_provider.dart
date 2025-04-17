import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_project/common/constants/env_constants.dart';
import 'package:flutter_project/data/datasources/common_api_call.dart';
import 'package:flutter_project/data/models/common_model/model_response_extend.dart';
import 'package:flutter_project/data/models/app_model/terms_and_conditions_model.dart';
import 'package:flutter_project/domain/entities/app_error.dart';
import 'package:flutter_project/domain/usecases/api_usecase.dart';
import 'package:flutter_project/presentation/provider/common_provider/loading_provider.dart';
import 'package:flutter_project/presentation/widgets/custom_snackbar.dart';
import 'package:flutter_project/presentation/journeys/screens/privacy_and_terms/privacy_and_terms_screen.dart';
import 'package:flutter_project/presentation/utils/app_functions.dart';

class TermsConditionProvider extends ChangeNotifier {
  late LoadingProvider loadingProvider;
  late ApiUsecase _apiUsecase;

  // State variables
  bool isLoading = false;
  TermsModelData? termsData;
  String? errorMessage;
  AppErrorType? errorType;

  TermsConditionProvider({
    required this.loadingProvider,
    required ApiUsecase apiUsecase,
  }) : _apiUsecase = apiUsecase;

  void updateUsecase(ApiUsecase usecase) {
    _apiUsecase = usecase;
  }

  Future<void> fetchTermsCondition<T extends ModelResponseExtend>({required TypeScreen typeScreen}) async {
    final endpoint = dotenv.env[EnvConstants.API_ENDPOINT_1];
    if (endpoint == null) return;

    isLoading = true;
    notifyListeners();

    Either<AppError, T> response = await _apiUsecase.call(
      endpoint: endpoint,
      fromJson: (result) => TermsAndConditionsModel.fromJson(result) as T,
      apiCallType: APICallType.GET,
      screenName: typeScreen == TypeScreen.PRIVACY_CONDITION ? 'Privacy Policy' : 'Terms Condition',
    );

    response.fold(
      (error) async {
        isLoading = false;
        errorMessage = error.message;
        errorType = error.errorType;
        notifyListeners();

        if (error.errorType == AppErrorType.unauthorised) {
          await AppFunctions().forceLogout();
        } else {
          CustomSnackbar.show(snackbarType: SnackbarType.ERROR, message: error.message);
        }
      },
      (data) async {
        isLoading = false;
        termsData = data is TermsAndConditionsModel ? data.data : null;
        notifyListeners();
      },
    );
  }
}
