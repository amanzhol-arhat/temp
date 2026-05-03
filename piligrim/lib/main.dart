import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
// Обязательно импортируем наш новый экран инициации
import 'features/splash/splash_screen.dart'; 

void main() {
  runApp(
    // ProviderScope оборачивает приложение для работы Riverpod
    const ProviderScope(
      child: PiligrimApp(),
    ),
  );
}

class PiligrimApp extends StatelessWidget {
  const PiligrimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Piligrim',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // Просто вызываем SplashScreen, он сам отрисует всю анимацию и перекинет на MainScreen
      home: const SplashScreen(), 
    );
  }
}