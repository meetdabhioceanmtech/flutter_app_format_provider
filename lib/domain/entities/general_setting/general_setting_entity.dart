// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import 'package:flutter_project/data/models/general_setting_model.dart';

part 'general_setting_entity.g.dart';

@HiveType(typeId: 3)
class GeneralSettingEntity extends Equatable {
  @HiveField(0)
  final List<Sector> sectors;
  @HiveField(1)
  final List<UserLanguage> yearOfExperiance;
  @HiveField(2)
  final List<UserLanguage> userLanguages;
  @HiveField(3)
  final String mobileNumber;
  @HiveField(4)
  final String email;
  @HiveField(5)
  final String supportingTiming;
  @HiveField(6)
  final List<String> positionfor;
  @HiveField(7)
  final String basePath;

  const GeneralSettingEntity({
    required this.sectors,
    required this.yearOfExperiance,
    required this.userLanguages,
    required this.mobileNumber,
    required this.email,
    required this.supportingTiming,
    required this.positionfor,
    required this.basePath,
  });

  GeneralSettingEntity copyWith({
    List<Sector>? sectors,
    List<UserLanguage>? yearOfExperiance,
    List<UserLanguage>? userLanguages,
    String? mobileNumber,
    String? whatsappNumber,
    String? email,
    String? supportingTiming,
    List<String>? positionfor,
    String? basePath,
  }) {
    return GeneralSettingEntity(
      sectors: sectors ?? this.sectors,
      yearOfExperiance: yearOfExperiance ?? this.yearOfExperiance,
      userLanguages: userLanguages ?? this.userLanguages,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      supportingTiming: supportingTiming ?? this.supportingTiming,
      positionfor: positionfor ?? this.positionfor,
      basePath: basePath ?? this.basePath,
    );
  }

  @override
  List<Object?> get props => [
        sectors,
        yearOfExperiance,
        userLanguages,
        mobileNumber,
        email,
        supportingTiming,
        positionfor,
        basePath,
      ];
}
