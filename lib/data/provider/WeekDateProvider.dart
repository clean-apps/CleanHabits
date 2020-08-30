class WeekDateProvider {
  static int currentWeek({bool startWithMonday = true}) {
    return weekOfYear(
      date: DateTime.now(),
      startWithMonday: startWithMonday,
    );
  }

  static int weekOfYear({bool startWithMonday = true, DateTime date}) {
    //
    DateTime weekStartDay = weekStart(
      date: date,
      startWithMonday: startWithMonday,
    );

    DateTime first = weekYearStartDate(weekStartDay.year);

    int week = 1 + (weekStartDay.difference(first).inDays / 7).round();

    if (week == 53 && DateTime(weekStartDay.year, 12, 31).weekday < 4) week = 1;

    return week;
  }

  static DateTime weekStart({bool startWithMonday = true, DateTime date}) {
    // This is ugly, but to avoid problems with daylight saving
    DateTime monday = DateTime.utc(date.year, date.month, date.day);
    monday = monday.subtract(Duration(days: monday.weekday - 1));

    if (startWithMonday) {
      return date.weekday == DateTime.monday
          ? DateTime.utc(date.year, date.month, date.day)
          : monday;
      //
    } else {
      DateTime sunday = monday.subtract(Duration(days: 1));
      return date.weekday == DateTime.sunday
          ? DateTime.utc(date.year, date.month, date.day)
          : sunday;
    }
  }

  static DateTime weekYearStartDate(int year) {
    final firstDayOfYear = DateTime.utc(year, 1, 1);
    final dayOfWeek = firstDayOfYear.weekday;

    return firstDayOfYear.add(
      Duration(
        days: (dayOfWeek <= DateTime.thursday ? 1 : 8) - dayOfWeek,
      ),
    );
  }
}
