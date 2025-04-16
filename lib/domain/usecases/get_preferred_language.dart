import 'package:dartz/dartz.dart';
import 'package:flutter_project/data/repositories/app_repository.dart';
import 'package:flutter_project/domain/entities/app_error.dart';
import 'package:flutter_project/domain/params/no_params.dart';
import 'package:flutter_project/domain/usecases/usecase.dart';

class GetPreferredLanguage extends UseCase<String, NoParams> {
  final AppRepository appRepository;

  GetPreferredLanguage({required this.appRepository});

  @override
  Future<Either<AppError, String>> call(NoParams params) async {
    return await appRepository.getPreferredLanguage();
  }
}
