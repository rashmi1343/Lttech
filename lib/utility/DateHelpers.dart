extension DateHelpers on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  DateTime addYears(int years) {
    return copyWith(year: this.year + years);
  }

  DateTime addMonths(int months) {
    return copyWith(month: this.month + months);
  }

  DateTime addWeeks(int weeks) {
    return copyWith(day: this.day + weeks*7);
  }

  DateTime addDays(int days) {
    return copyWith(day: this.day + days);
  }
}