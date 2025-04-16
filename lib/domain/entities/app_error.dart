import 'package:equatable/equatable.dart';

class AppError extends Equatable {
  final AppErrorType errorType;
  final String message;
  const AppError({required this.errorType, required this.message});

  @override
  List<Object> get props => [errorType];
}

enum AppErrorType { api, network, database, login, otp, data, unauthorised, app, unknown }
