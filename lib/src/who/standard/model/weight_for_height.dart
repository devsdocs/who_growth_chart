part of '../standard.dart';

class WeightForHeightData {
  WeightForHeightData()
      : _data = (json.decode(_wfhanthro) as Map<String, dynamic>).map(
          (u, e) => MapEntry(
            u,
            WeightForHeightGender(
              heightData: (e as Map<String, dynamic>).map((x, y) {
                y as Map<String, dynamic>;
                return MapEntry(
                  x,
                  WeightForHeightLMS(
                    lms: (l: y['l'], m: y['m'], s: y['s']),
                    lorh: y['lorh'].toString().toLowerCase() == 'l'
                        ? LengthHeigthMeasurementPosition.recumbent
                        : LengthHeigthMeasurementPosition.standing,
                  ),
                );
              }),
            ),
          ),
        );

  final Map<String, WeightForHeightGender> _data;
}

class WeightForHeight {
  WeightForHeight({
    required Sex sex,
    required Age age,
    required Length height,
    required Mass mass,
    required LengthHeigthMeasurementPosition measure,
    required WeightForHeightData weightForHeightData,
  })  : _lengthHeight = height,
        _measure = measure,
        _sex = sex,
        _mass = mass,
        _age = age,
        _mapGender = weightForHeightData._data {
    if (!(_adjustedHeight >= 65 && _adjustedHeight <= 120)) {
      if (height.toCentimeters.value! >= 65 &&
          height.toCentimeters.value! <= 120) {
        throw Exception('Please correcting measurement position based on age');
      } else {
        throw Exception('Height must be in range of 65 - 120 cm');
      }
    }
  }

  factory WeightForHeight.maleStandingPosition({
    required Length height,
    required Mass weight,
    required WeightForHeightData weightForHeightData,
    required Age age,
  }) =>
      WeightForHeight(
        sex: Sex.male,
        height: height,
        weightForHeightData: weightForHeightData,
        mass: weight,
        measure: LengthHeigthMeasurementPosition.standing,
        age: age,
      );

  factory WeightForHeight.maleRecumbentPosition({
    required Length length,
    required Mass weight,
    required WeightForHeightData weightForHeightData,
    required Age age,
  }) =>
      WeightForHeight(
        sex: Sex.male,
        height: length,
        weightForHeightData: weightForHeightData,
        mass: weight,
        measure: LengthHeigthMeasurementPosition.recumbent,
        age: age,
      );

  factory WeightForHeight.femaleStandingPosition({
    required Length height,
    required Mass weight,
    required WeightForHeightData weightForHeightData,
    required Age age,
  }) =>
      WeightForHeight(
        sex: Sex.female,
        height: height,
        mass: weight,
        weightForHeightData: weightForHeightData,
        measure: LengthHeigthMeasurementPosition.standing,
        age: age,
      );

  factory WeightForHeight.femaleRecumbentPosition({
    required Length length,
    required Mass weight,
    required WeightForHeightData weightForHeightData,
    required Age age,
  }) =>
      WeightForHeight(
        sex: Sex.female,
        height: length,
        mass: weight,
        weightForHeightData: weightForHeightData,
        measure: LengthHeigthMeasurementPosition.recumbent,
        age: age,
      );

  final Sex _sex;
  final Age _age;
  final Length _lengthHeight;
  final Mass _mass;
  final LengthHeigthMeasurementPosition _measure;
  final Map<String, WeightForHeightGender> _mapGender;

  num get _adjustedHeight => adjustedLengthHeight(
        measure: _measure,
        ageInDays: _age.totalDays,
        lengthHeight: _lengthHeight.toCentimeters.value!,
      );

  WeightForHeightGender get _maleData => _mapGender['1']!;
  WeightForHeightGender get _femaleData => _mapGender['2']!;

  WeightForHeightLMS get _ageData =>
      (_sex == Sex.male ? _maleData : _femaleData)
          .heightData[_adjustedHeight.toDouble().toPrecision(1).toString()]!;

  num get _zScore => adjustedZScore(
        y: _mass.toKilograms.value!,
        l: _ageData.lms.l,
        m: _ageData.lms.m,
        s: _ageData.lms.s,
      );

  num get zScore => _zScore.toDouble().toPrecision(2);

  num get percentile => zScoreToPercentile(_zScore).toDouble().toPrecision(2);
}

class WeightForHeightGender {
  WeightForHeightGender({required this.heightData});

  final Map<String, WeightForHeightLMS> heightData;
}

class WeightForHeightLMS {
  WeightForHeightLMS({
    required this.lms,
    required this.lorh,
  });
  final LMS lms;
  final LengthHeigthMeasurementPosition lorh;
}