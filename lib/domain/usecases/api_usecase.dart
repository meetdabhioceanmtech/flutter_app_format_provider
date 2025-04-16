import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_project/data/datasources/common_api_call.dart';
import 'package:flutter_project/data/models/model_response_extend.dart';
import 'package:flutter_project/domain/entities/app_error.dart';
import 'package:flutter_project/domain/repositories/api_repositorie.dart';

class ApiUsecase {
  final ApiDataRepositories dataRepositories;
  ApiUsecase({required this.dataRepositories});

  Future<Either<AppError, T>> call<T extends ModelResponseExtend>({
    required String endpoint,
    required T Function(Map<String, dynamic> json) fromJson,
    required APICallType apiCallType,
    required String screenName,
    Map<String, dynamic>? params,
    Map<String, String>? header,
    List<MapEntry<String, MultipartFile>>? multipleImages,
  }) {
    return dataRepositories.dataFatch(
      endpoint: endpoint,
      fromJson: fromJson,
      apiCallType: apiCallType,
      params: params,
      header: header,
      screenName: screenName,
      multipleImages: multipleImages,
    );
  }
}
