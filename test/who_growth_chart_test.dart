import 'package:test/test.dart';

import 'package:who_growth_standards/who_growth_standards.dart';

const dateBase = [28, 29, 30, 31];

void main() {
  final armCirData =
      ArmCircumferenceForAgeData(); // Initialize for the first and only time to avoid repeated parsing the same data

  final bodyMassIndexData =
      BodyMassIndexForAgeData(); // Initialize for the first and only time to avoid repeated parsing the same data
  group('A group of tests', () {
    test('Age', () {
      expect(
        Age.byMonthsAgo(2).totalDays,
        anyOf(
          dateBase.expand((element) => [element * 2, element * 2 + 1]).toList(),
        ),
      );
      expect(Age.byMonthsAgo(1).totalDays, anyOf(dateBase));
      expect(Age.byDaysAgo(30).totalDays, 30);
      expect(Age.byDaysAgo(1000).totalDays, 1000);
      expect(Age.byDaysAgo(10000).totalDays, 10000);
    });
    test('Arm Circ', () {
      expect(
        ArmCircumferenceForAge.male(
          age: Age.byMonthsAgo(24),
          measurementResult: const Centimeters(20.3),
          armCircumferenceData: armCirData,
        ).zScore,
        anyOf(3.79, 3.80),
      );
      expect(
        ArmCircumferenceForAge.male(
          age: Age.byMonthsAgo(44),
          measurementResult: const Centimeters(11.5),
          armCircumferenceData: armCirData,
        ).zScore,
        -4.11,
      );
      expect(
        ArmCircumferenceForAge.male(
          age: Age.byMonthsAgo(28),
          measurementResult: const Centimeters(17.4),
          armCircumferenceData: armCirData,
        ).zScore,
        1.57,
      );
    });
    test('BMI', () {
      expect(
        BodyMassIndexForAge.male(
          bodyMassIndexMeasurement: BodyMassIndexMeasurement.fromValue(
            20.5,
            age: Age.byMonthsAgo(44),
          ),
          bodyMassIndexData: bodyMassIndexData,
        ).zScore,
        3.40,
      );
      expect(
        BodyMassIndexForAge.male(
          bodyMassIndexMeasurement:
              BodyMassIndexMeasurement.fromValue(12, age: Age.byMonthsAgo(28)),
          bodyMassIndexData: bodyMassIndexData,
        ).zScore,
        anyOf(-3.76, -3.75),
      );
      expect(
        BodyMassIndexForAge.male(
          bodyMassIndexMeasurement: BodyMassIndexMeasurement.fromValue(
            18.8,
            age: Age.byMonthsAgo(52),
          ),
          bodyMassIndexData: bodyMassIndexData,
        ).zScore,
        anyOf(2.36, 2.37),
      );
    });
  });
}
