import 'package:flutter/material.dart';

class AppColors {
  static const Color earth = Color(0xFF3D3A38); // Қара жер (основной фон)
  static const Color sky = Color(0xFFF2EDE4); // Ақ аспан (текст)
  static const Color water = Color(0xFF7BA5B8); // Мөлдір су (акцент)
  static const Color steppe = Color(0xFFC4956A); // Сары дала (вторичный акцент)
  static const Color fruit = Color(0xFF8B1A1A); // Піскен жеміс (кнопки действий)
  static const Color earthDeep = Color(0xFF2A2826); // Глубокий фон для карточек и navbar
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.earth,
      fontFamily: 'Museo Sans',
      primaryColor: AppColors.water,
      
      // Настройка текстов по умолчанию
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.sky, fontWeight: FontWeight.w700),
        titleLarge: TextStyle(color: AppColors.sky, fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(color: AppColors.sky, fontWeight: FontWeight.w300),
        bodyMedium: TextStyle(color: AppColors.sky, fontWeight: FontWeight.w300),
      ),
      
      // Настройка карточек (скругление 16px)
      cardTheme: CardThemeData(
        color: AppColors.earthDeep,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
            color: AppColors.sky.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      
      // Настройка кнопок
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.water,
          foregroundColor: AppColors.sky,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Museo Sans',
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}