import 'package:flutter/material.dart';

class AppAnimations {
  static const kSplashDelay = Duration(milliseconds: 300);
  static const kSplashFadeDuration = Duration(milliseconds: 600);
  static const kSplashSlideDuration = Duration(milliseconds: 800);
  static const kSplashCurve = Curves.easeOutCubic;

  // Total time before navigating: delay + fade + slide + bg-fade + hold
  static const kSplashTotalDuration = Duration(milliseconds: 2100);
}

class AppAssets {
  // Путь к SVG для Splash Screen
  static const String splashPath = 'assets/svg/splash_path.svg';
  // Логотип
  static const String logo = 'assets/svg/piligrim.svg';
  // Тотемы для навигации
  static const String totemStar = 'assets/svg/star_totem.svg'; // Главная
  static const String totemBird = 'assets/svg/bird_totem.svg'; // Меню
  static const String totemTree = 'assets/svg/tree_totem.svg'; // Интерьер
  static const String totemWheel = 'assets/svg/wheel_totem.svg'; // Афиша
  static const String totemMoon = 'assets/svg/moon_totem.svg'; // Профиль
}
