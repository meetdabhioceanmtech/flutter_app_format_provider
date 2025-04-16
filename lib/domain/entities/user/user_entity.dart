import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'user_entity.g.dart';

@HiveType(typeId: 1)
class UserEntity extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String mobile;
  @HiveField(4)
  final String companyIcon;
  @HiveField(5)
  final String website;
  @HiveField(6)
  final String aboutCompany;
  @HiveField(7)
  final String establishYear;
  @HiveField(8)
  final String noEmployees;
  @HiveField(9)
  final String industryType;
  @HiveField(10)
  final String perksBenefits;
  @HiveField(11)
  final String interviewAddress;
  @HiveField(12)
  final String addressLat;
  @HiveField(13)
  final String addressLong;
  @HiveField(14)
  final StateData state;
  @HiveField(15)
  final CityData city;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.companyIcon,
    required this.website,
    required this.aboutCompany,
    required this.establishYear,
    required this.noEmployees,
    required this.industryType,
    required this.perksBenefits,
    required this.interviewAddress,
    required this.addressLat,
    required this.addressLong,
    required this.state,
    required this.city,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        mobile,
        companyIcon,
        website,
        aboutCompany,
        establishYear,
        noEmployees,
        industryType,
        perksBenefits,
        interviewAddress,
        addressLat,
        addressLong,
        state,
        city,
      ];
}

@HiveType(typeId: 6)
class StateData {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String countryName;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String code;
  @HiveField(4)
  final String sortName;

  StateData({
    required this.id,
    required this.countryName,
    required this.name,
    required this.code,
    required this.sortName,
  });

  factory StateData.fromJson(Map<String, dynamic> json) {
    return StateData(
      id: json['id'] ?? 0,
      countryName: json['country_name'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      sortName: json['sortname'] ?? '',
    );
  }
}

@HiveType(typeId: 7)
class CityData {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String stateId;
  @HiveField(2)
  final String stateName;
  @HiveField(3)
  final String cityName;
  @HiveField(4)
  final String sortName;

  CityData({
    required this.id,
    required this.stateId,
    required this.stateName,
    required this.cityName,
    required this.sortName,
  });

  factory CityData.fromJson(Map<String, dynamic> json) {
    return CityData(
      id: json['id'] ?? 0,
      stateId: json['state_id']?.toString() ?? '0',
      stateName: json['state_name'] ?? '',
      cityName: json['city_name'] ?? '',
      sortName: json['sortname'] ?? '',
    );
  }
}
