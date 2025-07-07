import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppThemes {
  // Define color variables for easy customization
  static const Color _lightPrimary = Color(0xFF2C3E50);
  static const Color _lightSecondary = Color(0xFFD5A571); // Your preferred color
  static const Color _lightTertiary = Color(0xFF3498DB);
  static const Color _lightBackground = Color(0xFFFAFAFA);
  static const Color _lightSurface = Colors.white;
  static const Color _lightSurfaceVariant = Color(0xFFF5F5F5);
  static const Color _lightOnSurface = Color(0xFF2C3E50);
  static const Color _lightOutline = Color(0xFFE0E0E0);
  
  static const Color _darkPrimary = Color(0xFFD5A571); // Your preferred color
  static const Color _darkSecondary = Color(0xFF3498DB);
  static const Color _darkTertiary = Color(0xFF2ECC71);
  static const Color _darkBackground = Color(0xFF121212);
  static const Color _darkSurface = Color(0xFF1E1E1E);
  static const Color _darkSurfaceVariant = Color(0xFF2C2C2C);
  static const Color _darkOnSurface = Color(0xFFF5F5F5);
  static const Color _darkOutline = Color(0xFF404040);

  // Enhanced Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: _lightBackground,
    primaryColor: _lightPrimary,
    colorScheme: const ColorScheme.light(
      primary: _lightPrimary,
      secondary: _lightSecondary,
      tertiary: _lightTertiary,
      background: _lightBackground,
      surface: _lightSurface,
      surfaceVariant: _lightSurfaceVariant,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: _lightOnSurface,
      onBackground: _lightOnSurface,
      outline: _lightOutline,
      shadow: Color(0x1A000000),
    ),
    
    // Enhanced AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: _lightSurface,
      foregroundColor: _lightOnSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: _lightOnSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      iconTheme: IconThemeData(
        color: _lightPrimary,
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: _lightPrimary,
        size: 24,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      toolbarHeight: 64,
      shadowColor: Color(0x0A000000),
    ),

    // Enhanced Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _lightSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _lightOutline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _lightOutline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _lightSecondary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
      ),
      labelStyle: const TextStyle(
        color: Color(0xFF64748B),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: const TextStyle(
        color: Color(0xFF94A3B8),
        fontSize: 16,
      ),
    ),

    // Enhanced Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightSecondary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _lightSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _lightSecondary,
        side: const BorderSide(color: _lightSecondary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Enhanced Card Theme
    cardTheme: CardTheme(
      color: _lightSurface,
      elevation: 0,
      shadowColor: const Color(0x0A000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: _lightOutline, width: 1),
      ),
      margin: const EdgeInsets.all(8),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: _lightPrimary,
      size: 24,
    ),
  );

  // Enhanced Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _darkBackground,
    primaryColor: _darkPrimary,
    colorScheme: const ColorScheme.dark(
      primary: _darkPrimary,
      secondary: _darkSecondary,
      tertiary: _darkTertiary,
      background: _darkBackground,
      surface: _darkSurface,
      surfaceVariant: _darkSurfaceVariant,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: _darkOnSurface,
      onBackground: _darkOnSurface,
      outline: _darkOutline,
      shadow: Color(0x33000000),
    ),
    
    // Enhanced Dark AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: _darkSurface,
      foregroundColor: _darkOnSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: _darkOnSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      iconTheme: IconThemeData(
        color: _darkPrimary,
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: _darkPrimary,
        size: 24,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      toolbarHeight: 64,
      shadowColor: Color(0x33000000),
    ),

    // Enhanced Dark Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _darkOutline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _darkOutline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _darkPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
      ),
      labelStyle: const TextStyle(
        color: Color(0xFF94A3B8),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: const TextStyle(
        color: Color(0xFF64748B),
        fontSize: 16,
      ),
    ),

    // Enhanced Dark Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkPrimary,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _darkPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _darkPrimary,
        side: const BorderSide(color: _darkPrimary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Enhanced Dark Card Theme
    cardTheme: CardTheme(
      color: _darkSurface,
      elevation: 0,
      shadowColor: const Color(0x33000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: _darkOutline, width: 1),
      ),
      margin: const EdgeInsets.all(8),
    ),

    // Dark Icon Theme
    iconTheme: const IconThemeData(
      color: _darkPrimary,
      size: 24,
    ),
  );
}

// Color Constants Class for Easy Access
class AppColors {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF2C3E50);
  static const Color lightSecondary = Color(0xFFD5A571);
  static const Color lightTertiary = Color(0xFF3498DB);
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Colors.white;
  
  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFFD5A571);
  static const Color darkSecondary = Color(0xFF3498DB);
  static const Color darkTertiary = Color(0xFF2ECC71);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  
  // Common Colors
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
}