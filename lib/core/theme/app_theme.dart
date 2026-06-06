import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.backgroundDarkCard,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: AppColors.textDark,
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundDark,
          foregroundColor: AppColors.textDark,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: AppColors.backgroundDarkCard,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.backgroundDarkCard,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondaryDark,
          type: BottomNavigationBarType.fixed,
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondaryDark,
          indicatorColor: AppColors.primary,
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.backgroundDarkSurface,
          thickness: 1,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
              fontSize: 28),
          headlineMedium: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
              fontSize: 22),
          headlineSmall: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
              fontSize: 18),
          bodyLarge:
              TextStyle(color: AppColors.textDark, fontSize: 16),
          bodyMedium: TextStyle(
              color: AppColors.textSecondaryDark, fontSize: 14),
          bodySmall: TextStyle(
              color: AppColors.textSecondaryDark, fontSize: 12),
          labelLarge: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 14),
        ),
        iconTheme: const IconThemeData(color: AppColors.textDark),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primary,
        ),
      );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.backgroundLightCard,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: AppColors.textLight,
        ),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: AppColors.backgroundLightCard,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.backgroundLightCard,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondaryLight,
          type: BottomNavigationBarType.fixed,
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFE0E0E0),
          thickness: 1,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
              fontSize: 28),
          headlineMedium: TextStyle(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
              fontSize: 22),
          headlineSmall: TextStyle(
              color: AppColors.textLight,
              fontWeight: FontWeight.w600,
              fontSize: 18),
          bodyLarge:
              TextStyle(color: AppColors.textLight, fontSize: 16),
          bodyMedium: TextStyle(
              color: AppColors.textSecondaryLight, fontSize: 14),
          bodySmall: TextStyle(
              color: AppColors.textSecondaryLight, fontSize: 12),
          labelLarge: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 14),
        ),
        iconTheme: const IconThemeData(color: AppColors.textLight),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primary,
        ),
      );
}
