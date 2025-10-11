import 'package:intl/intl.dart';

/// 데이터 포맷팅을 위한 유틸리티 클래스입니다.
class Formatters {
  Formatters._();

  /// 숫자를 천 단위 콤마로 포맷팅
  static String number(int value) {
    return NumberFormat('#,###').format(value);
  }

  /// 걸음수 포맷팅 (간단한 표현)
  static String steps(int steps) {
    if (steps >= 10000) {
      final k = steps / 1000;
      return '${k.toStringAsFixed(1)}K';
    }
    return NumberFormat('#,###').format(steps);
  }

  /// 거리 포맷팅 (미터 -> km 자동 변환)
  static String distance(double meters) {
    if (meters >= 1000) {
      final km = meters / 1000;
      return '${km.toStringAsFixed(1)}km';
    }
    return '${meters.toInt()}m';
  }

  /// 시간 포맷팅 (초 -> 분:초)
  static String duration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// 날짜 포맷팅 (yyyy.MM.dd)
  static String date(DateTime dateTime) {
    return DateFormat('yyyy.MM.dd').format(dateTime);
  }

  /// 시간 포맷팅 (HH:mm)
  static String time(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// 날짜와 시간 포맷팅 (MM.dd HH:mm)
  static String dateTime(DateTime dateTime) {
    return DateFormat('MM.dd HH:mm').format(dateTime);
  }

  /// 상대적 시간 포맷팅 (방금 전, 1분 전, 1시간 전 등)
  static String relativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }

  /// 행복도 퍼센트 포맷팅
  static String happiness(int happiness) {
    return '$happiness%';
  }

  /// 레벨 포맷팅
  static String level(int level) {
    return 'Lv.$level';
  }

  /// 파일 크기 포맷팅
  static String fileSize(int bytes) {
    if (bytes >= 1024 * 1024) {
      final mb = bytes / (1024 * 1024);
      return '${mb.toStringAsFixed(1)}MB';
    } else if (bytes >= 1024) {
      final kb = bytes / 1024;
      return '${kb.toStringAsFixed(1)}KB';
    }
    return '${bytes}B';
  }

  /// 칼로리 포맷팅
  static String calories(double calories) {
    return '${calories.toInt()}kcal';
  }

  /// 성취도/진행률 포맷팅
  static String progress(double progress) {
    final percent = (progress * 100).toInt();
    return '$percent%';
  }

  /// 온도 포맷팅
  static String temperature(double celsius) {
    return '${celsius.toInt()}°C';
  }

  /// 속도 포맷팅 (m/s -> km/h)
  static String speed(double metersPerSecond) {
    final kmh = metersPerSecond * 3.6;
    return '${kmh.toStringAsFixed(1)}km/h';
  }
}