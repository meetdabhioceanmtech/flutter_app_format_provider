import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_project/data/datasources/common_api_call.dart';
import 'package:flutter_project/data/models/model_response_extend.dart';
import 'package:flutter_project/domain/entities/app_error.dart';

abstract class ApiDataRepositories {
  Future<Either<AppError, T>> dataFatch<T extends ModelResponseExtend>({
    required String endpoint,
    required T Function(Map<String, dynamic> json) fromJson,
    required APICallType apiCallType,
    required String screenName,
    Map<String, dynamic>? params,
    Map<String, String>? header,
    List<MapEntry<String, MultipartFile>>? multipleImages,
  });
}
