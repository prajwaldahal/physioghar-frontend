import 'package:intl/intl.dart';

String formatDayMonth(DateTime date) => DateFormat('d MMM').format(date);

String formatFullDate(DateTime date) => DateFormat('d MMM yyyy').format(date);

String formatLongDate(DateTime date) =>
    DateFormat('EEEE, d MMMM yyyy').format(date);

String formatWeekdayShort(DateTime date) => DateFormat('E').format(date);

String formatTime(DateTime date) => DateFormat('h:mm a').format(date);

String formatDateTime(DateTime date) =>
    '${formatFullDate(date)} · ${formatTime(date)}';

DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

DateTime startOfWeek(DateTime date) {
  final day = dateOnly(date);
  return day.subtract(Duration(days: day.weekday - DateTime.monday));
}

List<DateTime> weekOf(DateTime date) {
  final start = startOfWeek(date);
  return [for (var i = 0; i < 7; i++) start.add(Duration(days: i))];
}

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

bool isToday(DateTime date) => isSameDay(date, DateTime.now());

String relativeDayLabel(DateTime date) {
  final today = dateOnly(DateTime.now());
  final target = dateOnly(date);
  final diff = target.difference(today).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Tomorrow';
  if (diff == -1) return 'Yesterday';
  return formatFullDate(date);
}
