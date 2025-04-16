// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserEntityAdapter extends TypeAdapter<UserEntity> {
  @override
  final int typeId = 1;

  @override
  UserEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserEntity(
      id: fields[0] as int,
      name: fields[1] as String,
      email: fields[2] as String,
      mobile: fields[3] as String,
      companyIcon: fields[4] as String,
      website: fields[5] as String,
      aboutCompany: fields[6] as String,
      establishYear: fields[7] as String,
      noEmployees: fields[8] as String,
      industryType: fields[9] as String,
      perksBenefits: fields[10] as String,
      interviewAddress: fields[11] as String,
      addressLat: fields[12] as String,
      addressLong: fields[13] as String,
      state: fields[14] as StateData,
      city: fields[15] as CityData,
    );
  }

  @override
  void write(BinaryWriter writer, UserEntity obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.mobile)
      ..writeByte(4)
      ..write(obj.companyIcon)
      ..writeByte(5)
      ..write(obj.website)
      ..writeByte(6)
      ..write(obj.aboutCompany)
      ..writeByte(7)
      ..write(obj.establishYear)
      ..writeByte(8)
      ..write(obj.noEmployees)
      ..writeByte(9)
      ..write(obj.industryType)
      ..writeByte(10)
      ..write(obj.perksBenefits)
      ..writeByte(11)
      ..write(obj.interviewAddress)
      ..writeByte(12)
      ..write(obj.addressLat)
      ..writeByte(13)
      ..write(obj.addressLong)
      ..writeByte(14)
      ..write(obj.state)
      ..writeByte(15)
      ..write(obj.city);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StateDataAdapter extends TypeAdapter<StateData> {
  @override
  final int typeId = 6;

  @override
  StateData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StateData(
      id: fields[0] as int,
      countryName: fields[1] as String,
      name: fields[2] as String,
      code: fields[3] as String,
      sortName: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StateData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.countryName)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.code)
      ..writeByte(4)
      ..write(obj.sortName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CityDataAdapter extends TypeAdapter<CityData> {
  @override
  final int typeId = 7;

  @override
  CityData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CityData(
      id: fields[0] as int,
      stateId: fields[1] as String,
      stateName: fields[2] as String,
      cityName: fields[3] as String,
      sortName: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CityData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.stateId)
      ..writeByte(2)
      ..write(obj.stateName)
      ..writeByte(3)
      ..write(obj.cityName)
      ..writeByte(4)
      ..write(obj.sortName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CityDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
