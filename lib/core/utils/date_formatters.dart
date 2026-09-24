/// Shared date/time display helpers. Avoids duplicating 12-hour formatting
/// in reminder, appointment, and home screens.
class DateFormatters {
  const DateFormatters._();

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String time12h(DateTime time) {
    final hour = time.hour == 0
        ? 12
        : (time.hour > 12 ? time.hour - 12 : time.hour);
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  static String appointmentDateTime(DateTime dateTime) {
    final weekday = _weekdays[dateTime.weekday - 1];
    final month = _months[dateTime.month - 1];
    return '$weekday, $month ${dateTime.day}, ${dateTime.year}  •  ${time12h(dateTime)}';
  }

  static String longDate(DateTime date) {
    const fullMonths = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${fullMonths[date.month - 1]} ${date.day}';
  }
}
