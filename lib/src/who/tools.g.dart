// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tools.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MassMeasurementHistoryImpl _$$MassMeasurementHistoryImplFromJson(
        Map<String, dynamic> json) =>
    _$MassMeasurementHistoryImpl(
      Date.fromJson(json['date'] as Map<String, dynamic>),
      Mass.fromJson(json['measurement'] as Map<String, dynamic>),
      isOedema: json['isOedema'] as bool? ?? false,
    );

Map<String, dynamic> _$$MassMeasurementHistoryImplToJson(
        _$MassMeasurementHistoryImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toJson(),
      'measurement': instance.measurement.toJson(),
      'isOedema': instance.isOedema,
    };

_$LengthMeasurementHistoryImpl _$$LengthMeasurementHistoryImplFromJson(
        Map<String, dynamic> json) =>
    _$LengthMeasurementHistoryImpl(
      Date.fromJson(json['date'] as Map<String, dynamic>),
      Length.fromJson(json['measurement'] as Map<String, dynamic>),
      measurementPosition: $enumDecodeNullable(
              _$LengthHeightMeasurementPositionEnumMap,
              json['measurementPosition']) ??
          LengthHeightMeasurementPosition.recumbent,
    );

Map<String, dynamic> _$$LengthMeasurementHistoryImplToJson(
        _$LengthMeasurementHistoryImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toJson(),
      'measurement': instance.measurement.toJson(),
      'measurementPosition': _$LengthHeightMeasurementPositionEnumMap[
          instance.measurementPosition],
    };

const _$LengthHeightMeasurementPositionEnumMap = {
  LengthHeightMeasurementPosition.recumbent: 'recumbent',
  LengthHeightMeasurementPosition.standing: 'standing',
};
