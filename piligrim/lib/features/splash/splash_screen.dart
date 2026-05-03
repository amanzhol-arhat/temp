import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../navigation/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Начальная прозрачность для анимации Fade-In
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    
    // Запускаем плавное появление через 200 миллисекунд после отрисовки экрана
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });

    // Ожидаем 3 секунды и делаем замену экрана (чтобы нельзя было вернуться по кнопке "Назад")
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            // Плавный переход (CrossFade) на MainScreen
            pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Получаем размеры экрана для точного позиционирования
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // Цвет фона "Қара жер" — тёмный земляной оттенок из палитры приложения
      backgroundColor: AppColors.earth,

      // body содержит весь контент заставки
      body: Stack(
        children: [
          // ─── Слой 1: SVG-логотип на весь экран ───────────────────────────
          // AnimatedOpacity плавно проявляет логотип с opacity 0.0 → 1.0
          AnimatedOpacity(
            opacity: _opacity,
            // Длительность анимации проявления: 1 секунда
            duration: const Duration(seconds: 1),
            // Плавное замедление в начале и конце анимации
            curve: Curves.easeInOut,

            // SizedBox.expand растягивает дочерний виджет на весь доступный
            // размер родителя (Stack занимает всё тело Scaffold)
            child: SizedBox(
              width: size.width,   // Полная ширина экрана
              height: size.height, // Полная высота экрана

              child: SvgPicture.asset(
                // Путь к SVG-файлу логотипа, описанный в AppAssets
                AppAssets.splashPath,

                // ColorFilter перекрашивает все пиксели SVG в цвет AppColors.sky
                // BlendMode.srcIn: используем форму источника, но цвет назначения
                colorFilter: const ColorFilter.mode(
                  AppColors.sky, // Цвет "небо" — голубой оттенок из палитры
                  BlendMode.srcIn,
                ),

                // BoxFit.cover растягивает SVG на весь экран, сохраняя пропорции
                // и обрезая лишнее по краям — изображение всегда заполняет экран целиком.
                fit: BoxFit.cover,
              ),
            ),
          ),
          // ─────────────────────────────────────────────────────────────────
          // Здесь можно добавить дополнительные слои поверх логотипа,
          // например, индикатор загрузки или версию приложения:
          //
          // Positioned(
          //   bottom: 32,
          //   left: 0, right: 0,
          //   child: Text('v1.0.0', textAlign: TextAlign.center, ...),
          // ),
        ],
      ),
    );
  }
}