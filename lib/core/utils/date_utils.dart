import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatMatchTime(String? isoDate) {
    if (isoDate == null) return '--:--';
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      return DateFormat('HH:mm').format(dt);
    } catch (_) {
      return '--:--';
    }
  }

  static String formatMatchDate(String? isoDate) {
    if (isoDate == null) return '';
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      return DateFormat('EEE, MMM d').format(dt);
    } catch (_) {
      return '';
    }
  }

  static String formatFullDateTime(String? isoDate) {
    if (isoDate == null) return '';
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      return DateFormat('EEE, MMM d · HH:mm').format(dt);
    } catch (_) {
      return '';
    }
  }
}
