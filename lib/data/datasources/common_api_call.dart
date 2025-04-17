// ignore_for_file: constant_identifier_names, unused_local_variable, unused_catch_stack

import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_project/data/core/api_client.dart';
import 'package:flutter_project/data/core/api_constants.dart';
import 'package:flutter_project/data/core/unathorised_exception.dart';
import 'package:flutter_project/data/models/common_model/model_response_extend.dart';
import 'package:flutter_project/domain/entities/app_error.dart';

enum APICallType { GET, POST, DIRECTGET, DIRECTPOST, POSTFILES, DELETE }

Future<Either<AppError, T>> commonApiCall<T extends ModelResponseExtend>({
  required T Function(Map<String, dynamic> json) fromJson,
  required ApiClient client,
  required String apiPath,
  Map<String, dynamic>? params,
  Map<String, String>? header,
  required APICallType apiCallType,
  List<MapEntry<String, dio.MultipartFile>>? multipleImages,
  required String screenName,
}) async {
  String paramsUrl;

  try {
    paramsUrl = client.getPathWithParams(apiPath, params: params ?? {});
    final data = apiCallType == APICallType.GET
        ? (await client.get(apiPath, params: params, header: header ?? ApiConstatnts().headers))
        : apiCallType == APICallType.POST
            ? (await client.post(apiPath, params: params, header: header ?? ApiConstatnts().headers))
            : apiCallType == APICallType.DIRECTGET
                ? (await client.directGet(
                    url: apiPath, params: params ?? {}, header: header ?? ApiConstatnts().headers))
                : apiCallType == APICallType.DIRECTPOST
                    ? (await client.directPost(
                        url: apiPath,
                        params: params ?? {},
                        header: header ?? ApiConstatnts().headers,
                      ))
                    : apiCallType == APICallType.DELETE
                        ? (await client.deleteWithBody(
                            apiPath,
                            params: params ?? {},
                            header: header ?? ApiConstatnts().headers,
                          ))
                        : (await client.postFiles(
                            apiPath,
                            params: params ?? {},
                            header: header ?? ApiConstatnts().headers,
                            multipleImages: multipleImages,
                          ));

    final parseData = fromJson(data);

    if (parseData.status && parseData.data != null) {
      return Right(parseData);
    } else {
      return Left(
        AppError(
          errorType: AppErrorType.api,
          message: parseData.message,
        ),
      );
    }
  } on UnauthorisedException catch (_) {
    return const Left(AppError(errorType: AppErrorType.unauthorised, message: "Un-Authorised"));
  } on SocketException catch (e, stackTrace) {
    return const Left(
      AppError(
        errorType: AppErrorType.network,
        message: "Please check your internet connection, try again!!!\n(Error:102)",
      ),
    );
  } catch (e) {
    log('=====>> ${e.toString()}');
    return const Left(
      AppError(
        errorType: AppErrorType.app,
        message: "Something went wrong, try again!\n(Error:105)",
      ),
    );
  }
}
