import 'package:flutter/material.dart';

/// WalkDog 앱의 색상 팔레트를 정의합니다.
class AppColors {
  AppColors._();

  // Primary Colors (강아지 테마 - 오렌지/갈색 계열)
  static const Color primary = Color(0xFFFF8A50);
  static const Color primaryDark = Color(0xFFE55D00);
  static const Color primaryLight = Color(0xFFFFB584);

  // Secondary Colors (자연/산책 테마 - 그린 계열)
  static const Color secondary = Color(0xFF4CAF50);
  static const Color secondaryDark = Color(0xFF388E3C);
  static const Color secondaryLight = Color(0xFF81C784);

  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // Accent Colors (감정 표현용)
  static const Color happy = Color(0xFFFFC107);
  static const Color excited = Color(0xFFFF5722);
  static const Color sad = Color(0xFF607D8B);
  static const Color sleepy = Color(0xFF9C27B0);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Neutral Colors
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Progress Colors (행복도 게이지용)
  static const Color progressLow = Color(0xFFE53935);
  static const Color progressMedium = Color(0xFFFF9800);
  static const Color progressHigh = Color(0xFF4CAF50);
  static const Color progressFull = Color(0xFF2196F3);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFFFF8A50),
    Color(0xFFFFB584),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF4CAF50),
    Color(0xFF81C784),
  ];

  static const List<Color> happinessGradient = [
    Color(0xFFE53935),
    Color(0xFFFF9800),
    Color(0xFF4CAF50),
  ];

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x80000000);

  // Card Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBackgroundDark = Color(0xFF2C2C2C);
  static const Color cardBorder = Color(0xFFE0E0E0);
  static const Color cardBorderDark = Color(0xFF424242);
}