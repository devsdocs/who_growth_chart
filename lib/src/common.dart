import 'package:who_growth_standards/src/types.dart';

Months _monthFromNumber(int number) =>
    Months.values.singleWhere((element) => element.number == number);

bool _assertDateOfBirth(_DateOfBirth dob) {
  if (dob.date > _TimeTools._datesInMonth(dob.year, dob.month.number)) {
    return false;
  }
  return true;
}

class Age {
  Age._(_DateOfBirth dateOfBirth)
      : assert(_assertDateOfBirth(dateOfBirth)),
        _dobCount = _TimeIntervalCount(
          dateOfBirth.year,
          dateOfBirth.month.number,
          dateOfBirth.date,
        );

  factory Age.byYearsAgo(int years) {
    return Age._(_DateOfBirth.byYearsAgo(years));
  }
  factory Age.byMonthsAgo(int months) {
    return Age._(_DateOfBirth.byMonthsAgo(months));
  }
  factory Age.byDaysAgo(int days) {
    return Age._(_DateOfBirth.byDaysAgo(days));
  }
  factory Age.byBirthDate(DateTime birthDate) {
    return Age._(_DateOfBirth.fromDateTime(birthDate));
  }

  final _TimeIntervalCount _dobCount;

  _Age get _ageNowIn => _dobCount.ageNow;

  int get years => _ageNowIn.years;
  int get months => _ageNowIn.months;
  int get days => _ageNowIn.days;

  int get totalDays => DateTime.now().difference(_dobCount._dob).inDays;
}

class _DateOfBirth {
  _DateOfBirth._({required this.year, required this.month, required this.date});

  factory _DateOfBirth.byDaysAgo(int days) {
    final calc = _TimeTools._calculateBirthDateInDays(days);
    return _DateOfBirth._(
      year: calc.year,
      month: _monthFromNumber(calc.month),
      date: calc.day,
    );
  }

  factory _DateOfBirth.byMonthsAgo(int months) {
    final calc = _TimeTools._calculateBirthDateInMonths(months);
    return _DateOfBirth._(
      year: calc.year,
      month: _monthFromNumber(calc.month),
      date: calc.day,
    );
  }

  factory _DateOfBirth.byYearsAgo(int years) {
    final calc = _TimeTools._calculateBirthDateInYears(years);
    return _DateOfBirth._(
      year: calc.year,
      month: _monthFromNumber(calc.month),
      date: calc.day,
    );
  }

  factory _DateOfBirth.fromDateTime(DateTime dateTime) {
    return _DateOfBirth._(
      year: dateTime.year,
      month: _monthFromNumber(dateTime.month),
      date: dateTime.day,
    );
  }

  final int year;
  final Months month;
  final int date;
}

class _TimeTools {
  /// _daysInMonth cost contains days per months; daysInMonth method to be used instead.
  static final List<int> _daysInMonth = [
    31, // Jan
    28, // Feb, it varies from 28 to 29
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31, // Dec
  ];

  /// isLeapYear method
  static bool _isLeapYear(int year) =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

  /// daysInMonth method
  static int _datesInMonth(int year, int month) =>
      (month == DateTime.february && _isLeapYear(year))
          ? 29
          : _daysInMonth[month - 1];

  static DateTime _calculateBirthDateInDays(int daysOld) {
    // Get the current date
    final DateTime currentDate = DateTime.now();

    // Calculate the target date
    final DateTime targetDate = currentDate.subtract(Duration(days: daysOld));

    return targetDate;
  }

  static DateTime _calculateBirthDateInYears(int yearsOld) {
    // Get the current date
    final DateTime currentDate = DateTime.now();

    // Calculate the target date
    final DateTime targetDate = currentDate
        .subtract(Duration(days: _yearsToDays(yearsOld, currentDate)));

    return targetDate;
  }

  static DateTime _calculateBirthDateInMonths(int monthsOld) {
    // Get the current date
    final DateTime currentDate = DateTime.now();

    // Calculate the target date
    final DateTime targetDate = currentDate.subtract(
      Duration(
        days: _monthsToDays(currentDate.year, currentDate.month, monthsOld),
      ),
    );

    return targetDate;
  }

  static int _yearsToDays(int years, DateTime currentDate) {
    // Calculate the total number of days in the given years, considering leap years
    int days = 0;
    for (int i = 0; i < years; i++) {
      days += _isLeapYear(currentDate.year - i) ? 366 : 365;
    }

    return days;
  }

  static int _monthsToDays(int year, int startingMonth, int months) {
    // Calculate the total number of days in the given months
    int days = 0;
    int currentMonth = startingMonth;
    int y = year;

    for (int i = 0; i < months; i++) {
      days += DateTime(y, currentMonth, 0).day;
      currentMonth++;

      if (currentMonth > 12) {
        currentMonth = 1;
        y++;
      }
    }

    return days;
  }

  // static DateTime _calculateBirthDate({
  //   required int years,
  //   required int months,
  //   required int days,
  // }) {
  //   // Get the current date
  //   final DateTime workingDate = DateTime.now();

  //   // Calculate the target date
  //   DateTime targetDate = workingDate.subtract(
  //     Duration(
  //       days: days,
  //       hours: workingDate.hour,
  //       minutes: workingDate.minute,
  //       seconds: workingDate.second,
  //       milliseconds: workingDate.millisecond,
  //       microseconds: workingDate.microsecond,
  //     ),
  //   );

  //   // Adjust the target date based on years and months
  //   targetDate =
  //       targetDate.subtract(Duration(days: _yearsToDays(years, targetDate)));
  //   targetDate = targetDate.subtract(
  //     Duration(
  //       days: _monthsToDays(targetDate.year, targetDate.month, months),
  //     ),
  //   );

  //   return targetDate;
  // }
}

class _TimeIntervalCount {
  _TimeIntervalCount(
    int year, [
    int month = 1,
    int date = 1,
    int hours = 0,
    int minutes = 0,
  ]) : _dob = DateTime(
          year,
          month,
          date,
          hours,
          minutes,
        ) {
    if (date > _TimeTools._datesInMonth(year, month)) {
      throw Exception('Days exceeded');
    }
  }

  final DateTime _dob;

  _Age _timeDifference({
    required DateTime fromDate,
    required DateTime toDate,
  }) {
    // Check if toDate to be included in the calculation
    final DateTime endDate = toDate;

    int years = endDate.year - fromDate.year;
    int months = 0;
    int days = 0;
    int hours = 0;
    int minutes = 0;

    if (fromDate.month > endDate.month) {
      years--;
      months = DateTime.monthsPerYear + endDate.month - fromDate.month;

      if (fromDate.day > endDate.day) {
        months--;
        days = _TimeTools._datesInMonth(
              fromDate.year + years,
              ((fromDate.month + months - 1) % DateTime.monthsPerYear) + 1,
            ) +
            endDate.day -
            fromDate.day;
      } else {
        days = endDate.day - fromDate.day;
      }
    } else if (endDate.month == fromDate.month) {
      if (fromDate.day > endDate.day) {
        years--;
        months = DateTime.monthsPerYear - 1;
        days = _TimeTools._datesInMonth(
              fromDate.year + years,
              ((fromDate.month + months - 1) % DateTime.monthsPerYear) + 1,
            ) +
            endDate.day -
            fromDate.day;
      } else {
        days = endDate.day - fromDate.day;
      }
    } else {
      months = endDate.month - fromDate.month;

      if (fromDate.day > endDate.day) {
        months--;
        days = _TimeTools._datesInMonth(
              fromDate.year + years,
              fromDate.month + months,
            ) +
            endDate.day -
            fromDate.day;
      } else {
        days = endDate.day - fromDate.day;
      }
    }

    if (fromDate.hour > endDate.hour) {
      days--;
      hours = 24 - fromDate.hour + endDate.hour;
    } else {
      hours = endDate.hour - fromDate.hour;
    }

    if (fromDate.minute > endDate.minute) {
      hours--;
      minutes = 60 - fromDate.minute + endDate.minute;
    } else {
      minutes = endDate.minute - fromDate.minute;
    }

    return _Age(
      days: days,
      months: months,
      years: years,
      hours: hours,
      minutes: minutes,
    );
  }

  /// add method
  DateTime _add({
    required DateTime date,
    required _Age duration,
  }) {
    int years = date.year + duration.years;
    years += (date.month + duration.months) ~/ DateTime.monthsPerYear;
    final int months = (date.month + duration.months) % DateTime.monthsPerYear;

    final int days = date.day + duration.days - 1;

    return DateTime(years, months).add(Duration(days: days));
  }

  _Age _ageAtDate(DateTime day) {
    return _timeDifference(
      fromDate: _dob,
      toDate: day,
    );
  }

  _Age get ageNow => _ageAtDate(DateTime.now());
  _Age get timeUntilNextBirthdayFromNow =>
      _timeUntilNextBirthday(DateTime.now());

  _Age _timeUntilNextBirthday(DateTime fromDate) {
    final DateTime endDate = fromDate;
    final DateTime tempDate = DateTime(endDate.year, _dob.month, _dob.day);
    final DateTime nextBirthdayDate = tempDate.isBefore(endDate)
        ? _add(date: tempDate, duration: _Age(years: 1))
        : tempDate;
    return _timeDifference(fromDate: endDate, toDate: nextBirthdayDate);
  }
}

class _Age {
  _Age({
    this.days = 0,
    this.months = 0,
    this.years = 0,
    this.hours = 0,
    this.minutes = 0,
  });
  int days;
  int months;
  int years;
  int hours;
  int minutes;
}
