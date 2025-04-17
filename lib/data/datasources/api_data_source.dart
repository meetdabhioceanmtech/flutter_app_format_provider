import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_project/data/datasources/common_api_call.dart';
import 'package:flutter_project/data/core/api_client.dart';
import 'package:flutter_project/data/models/common_model/model_response_extend.dart';
import 'package:flutter_project/domain/entities/app_error.dart';

abstract class ApiDataSource {
  Future<Either<AppError, T>> dataFatchApi<T extends ModelResponseExtend>({
    required String endpoint,
    required T Function(Map<String, dynamic> json) fromJson,
    required APICallType apiCallType,
    required String screenName,
    Map<String, dynamic>? params,
    Map<String, String>? header,
    List<MapEntry<String, MultipartFile>>? multipleImages,
  });
}

class ApiDataSourceImpl extends ApiDataSource {
  final ApiClient client;

  ApiDataSourceImpl({required this.client});

  @override
  Future<Either<AppError, T>> dataFatchApi<T extends ModelResponseExtend>({
    required String endpoint,
    required T Function(Map<String, dynamic> json) fromJson,
    required APICallType apiCallType,
    Map<String, dynamic>? params,
    Map<String, String>? header,
    required String screenName,
    List<MapEntry<String, MultipartFile>>? multipleImages,
  }) async {
    try {
      // Perform the API call using commonApiCall
      final result = await commonApiCall<T>(
        apiPath: endpoint,
        apiCallType: apiCallType,
        client: client,
        screenName: screenName,
        fromJson: fromJson,
        params: params,
        header: header,
        multipleImages: multipleImages,
      );

      // Return the result as either success or failure
      return result.fold(
        (appError) => Left(appError),
        (data) => Right(data),
      );
    } catch (e) {
      // Handle other exceptions
      return Left(AppError(message: 'Error occurred during API call', errorType: AppErrorType.network));
    }
  }
}
