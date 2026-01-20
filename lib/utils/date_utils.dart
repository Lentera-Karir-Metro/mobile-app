import 'package:intl/intl.dart';

class DateUtils {
  static String formatDate(DateTime date, {String format = 'dd MMM yyyy'}) {
    return DateFormat(format, 'id_ID').format(date);
  }

  static String formatDateWithTime(
    DateTime date, {
    String format = 'dd MMM yyyy HH:mm',
  }) {
    return DateFormat(format, 'id_ID').format(date);
  }

  static String formatTime(DateTime date, {String format = 'HH:mm'}) {
    return DateFormat(format).format(date);
  }

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years tahun yang lalu';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months bulan yang lalu';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  static String formatTimeAgo(DateTime date) {
    return formatRelative(date);
  }

  static String formatDateRange(DateTime startDate, DateTime endDate) {
    if (startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day) {
      return formatDate(startDate);
    }

    if (startDate.year == endDate.year && startDate.month == endDate.month) {
      return '${startDate.day} - ${formatDate(endDate)}';
    }

    return '${formatDate(startDate)} - ${formatDate(endDate)}';
  }

  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes menit';
    }

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (remainingMinutes == 0) {
      return '$hours jam';
    }

    return '$hours jam $remainingMinutes menit';
  }

  static String formatDurationFromSeconds(int seconds) {
    if (seconds < 60) {
      return '$seconds detik';
    }

    final minutes = seconds ~/ 60;
    return formatDuration(minutes);
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  static String formatSmartDate(DateTime date) {
    if (isToday(date)) {
      return 'Hari ini ${formatTime(date)}';
    } else if (isYesterday(date)) {
      return 'Kemarin ${formatTime(date)}';
    } else if (DateTime.now().difference(date).inDays < 7) {
      return '${DateFormat('EEEE', 'id_ID').format(date)} ${formatTime(date)}';
    } else {
      return formatDateWithTime(date);
    }
  }

  static DateTime? parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    return DateTime.tryParse(dateString);
  }

  static String formatCertificateDate(DateTime date) {
    return formatDate(date, format: 'dd MMMM yyyy');
  }

  static String formatExpiredDate(DateTime date) {
    final now = DateTime.now();
    if (date.isBefore(now)) {
      return 'Kedaluwarsa';
    }

    final difference = date.difference(now);
    if (difference.inDays > 30) {
      return 'Berlaku hingga ${formatDate(date)}';
    } else if (difference.inDays > 0) {
      return 'Berlaku ${difference.inDays} hari lagi';
    } else if (difference.inHours > 0) {
      return 'Berlaku ${difference.inHours} jam lagi';
    } else {
      return 'Akan kedaluwarsa';
    }
  }

  static int getDaysDifference(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays;
  }

  static bool isExpired(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  static String formatQuizTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
