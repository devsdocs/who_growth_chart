part of '../cdc.dart';

class CDCInfantWeightForLengthData {
  factory CDCInfantWeightForLengthData() => _singleton;
  CDCInfantWeightForLengthData._(this._data);

  static final _singleton = CDCInfantWeightForLengthData._(_parse());

  static Map<Sex, _CDCInfantWeightForLengthGender> _parse() =>
      cdcwtleninf.toJsonObjectAsMap.map(
        (k1, v1) => MapEntry(
          k1 == '1' ? Sex.male : Sex.female,
          _CDCInfantWeightForLengthGender(
            lengthData: (v1 as Map<String, dynamic>).map((k2, v2) {
              v2 as Map<String, dynamic>;
              final lms =
                  LMS(l: v2['l'] as num, m: v2['m'] as num, s: v2['s'] as num);
              return MapEntry(
                num.parse(k2),
                _CDCInfantWeightForLengthLMS(
                  lms: lms,
                  percentileCutOff: lms.percentileCutOff,
                  standardDeviationCutOff: lms.stDevCutOff,
                ),
              );
            }),
          ),
        ),
      );
  final Map<Sex, _CDCInfantWeightForLengthGender> _data;
  Map<Sex, _CDCInfantWeightForLengthGender> get data => _data;

  @override
  String toString() => 'Weight For Length Data($_data)';
}

@freezed
class CDCInfantWeightForLength with _$CDCInfantWeightForLength {
  //TODO(devsdocs): Test this!
  @Assert(
    'adjustedLengthHeight(measure: measure,age: age,lengthHeight: length, type: AdjustedLengthType.cdc,).value >= 45 && adjustedLengthHeight(measure: measure,age: age,lengthHeight: length, type: AdjustedLengthType.cdc,).value < 104 && length.toCentimeter.value >= 45 && length.toCentimeter.value < 104',
    'Please correcting measurement position based on age',
  )
  //TODO(devsdocs): Test this!
  @Assert(
    'adjustedLengthHeight(measure: measure,age: age,lengthHeight: length, type: AdjustedLengthType.cdc,).value >= 45 && adjustedLengthHeight(measure: measure,age: age,lengthHeight: length, type: AdjustedLengthType.cdc,).value < 104',
    'Length must be in range of 45.0 - 103.9 cm',
  )
  @Assert(
    'observationDate == null || observationDate.isSameOrBefore(Date.today()) || observationDate.isSameOrAfter(age.dateOfBirth)',
    'Observation date is impossible, because happen after today or before birth',
  )
  factory CDCInfantWeightForLength({
    Date? observationDate,
    required Sex sex,
    required Age age,
    required Length length,
    required Mass weight,
    required LengthHeightMeasurementPosition measure,
  }) = _CDCInfantWeightForLength;

  const CDCInfantWeightForLength._();

  factory CDCInfantWeightForLength.fromJson(Map<String, dynamic> json) =>
      _$CDCInfantWeightForLengthFromJson(json);

  num get _adjustedLength => adjustedLengthHeight(
        measure: measure,
        age: age,
        lengthHeight: length,
        type: AdjustedLengthType.cdc,
      ).value;

  CDCInfantWeightForLengthData get _weightForLengthData =>
      CDCInfantWeightForLengthData();

  _CDCInfantWeightForLengthGender get _maleData =>
      _weightForLengthData._data[Sex.male]!;
  _CDCInfantWeightForLengthGender get _femaleData =>
      _weightForLengthData._data[Sex.female]!;
//TODO(devsdocs): Fix CDC length calculation
  _CDCInfantWeightForLengthLMS get _ageData =>
      (sex == Sex.male ? _maleData : _femaleData).lengthData[
          _adjustedLength == 45 ? 45 : _adjustedLength.truncate() + 0.5]!;

  num get _zScore => _ageData.lms.zScore(weight.toKilogram.value);

  num zScore([
    Precision precision = Precision.ten,
  ]) =>
      _zScore.precision(precision);

  num percentile([
    Precision precision = Precision.ten,
  ]) =>
      (pnorm(_zScore) * 100).precision(precision);
}

class _CDCInfantWeightForLengthGender {
  _CDCInfantWeightForLengthGender({required this.lengthData});

  final Map<num, _CDCInfantWeightForLengthLMS> lengthData;
  @override
  String toString() => 'Gender Data($lengthData)';
}

class _CDCInfantWeightForLengthLMS {
  _CDCInfantWeightForLengthLMS({
    required this.lms,
    required this.standardDeviationCutOff,
    required this.percentileCutOff,
  });
  final LMS lms;

  final ZScoreCutOff standardDeviationCutOff;

  final PercentileCutOff percentileCutOff;

  @override
  String toString() =>
      'Length Data(LMS: $lms, Standard Deviation CutOff: $standardDeviationCutOff, Percentile CutOff: $percentileCutOff)';
}
