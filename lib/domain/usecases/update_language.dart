import 'package:dartz/dartz.dart';
import 'package:flutter_project/data/repositories/app_repository.dart';
import 'package:flutter_project/domain/entities/app_error.dart';
import 'package:flutter_project/domain/usecases/usecase.dart';

class UpdateLanguage extends UseCase<void, String> {
  final AppRepository appRepository;

  UpdateLanguage({required this.appRepository});

  @override
  Future<Either<AppError, void>> call(String params) async {
    return await appRepository.updateLanguage(params);
  }
}
