import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_project/common/constants/env_constants.dart';
import 'package:flutter_project/data/datasources/common_api_call.dart';
import 'package:flutter_project/data/models/model_response_extend.dart';
import 'package:flutter_project/data/models/my_notification_model.dart';
import 'package:flutter_project/domain/entities/app_error.dart';
import 'package:flutter_project/domain/usecases/api_usecase.dart';
import 'package:flutter_project/presentation/provider/loading/loading_provider.dart';
import 'package:flutter_project/presentation/custom_snackbar.dart';

class NotificationProvider extends ChangeNotifier {
  final LoadingProvider loadingProvider;
  late ApiUsecase _apiUsecase;

  List<NotificationData> notificationList = [];
  String? errorMessage;
  bool isLoading = false;

  NotificationProvider({
    required this.loadingProvider,
    required ApiUsecase apiUsecase,
  }) : _apiUsecase = apiUsecase;

  void updateUsecase(ApiUsecase usecase) {
    _apiUsecase = usecase;
  }

  Future<void> getNotificationHistory<T extends ModelResponseExtend>({bool isRefreshIndicator = false}) async {
    final endpoint = dotenv.env[EnvConstants.API_ENDPOINT_4];
    if (endpoint == null) return;

    if (!isRefreshIndicator) {
      _setLoadingState(true);
    }

    Either<AppError, T> response = await _apiUsecase.call(
      endpoint: endpoint,
      fromJson: (json) => MyNotification.fromJson(json) as T,
      apiCallType: APICallType.GET,
      screenName: "My Notification",
    );

    response.fold(
      (error) {
        _setLoadingState(false);
        errorMessage = error.message;
        notifyListeners();
        CustomSnackbar.show(
          snackbarType: SnackbarType.ERROR,
          message: error.message,
        );
      },
      (data) {
        if (data is MyNotification) {
          notificationList = data.data.notifications;
          _setLoadingState(false);
          notifyListeners();
        }
      },
    );
  }

  void _setLoadingState(bool loadingState) {
    isLoading = loadingState;
    notifyListeners();
  }
}
