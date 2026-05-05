import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/widgets/floating_totems_background.dart';

/// Главный экран приложения Piligrim.
///
/// Здесь реализован базовый каркас с анимированным фоном и
/// подготовленным местом под основной контент.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Основной фон экрана согласно дизайн-системе (#3D3A38)
      backgroundColor: Color(0xFF3D3A38),

      // Используем Stack для наложения контента поверх анимированного фона
      body: Stack(
        children: [
          // Первый слой: Плавающие тотемы (фоновая анимация)
          FloatingTotemsBackground(),

          // Второй слой: Безопасная зона для основного UI
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                const _StatusAndConceptWidget(),
                const SizedBox(height: 48),
                const _ActionButtons(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Виджет с логотипом, концепцией и статусом работы.
class _StatusAndConceptWidget extends StatelessWidget {
  const _StatusAndConceptWidget();

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFF2EDE4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Логотип ресторана
        SvgPicture.asset(
          'assets/svg/piligrim.svg', // Исправлено имя файла (убрана 's')
          height: 40,
          colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
        ),

        const SizedBox(height: 12),

        // Текст концепции
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Духовно-гастрономическое путешествие.\nВкус жизни. Путь героя.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: primaryColor.withValues(alpha: 0.8),
              fontSize: 16,
              fontWeight: FontWeight.w300,
              fontFamily: 'Museo Sans',
              height: 1.5, // Изменено с 1.4 на 1.5 согласно брендбуку
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Бейдж статуса
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8), // Изменено с 20 на 8 согласно брендбуку
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Индикатор "Открыто"
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF7BA5B8), // Использован акцентный цвет Мөлдір су, так как зеленый вне палитры
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Открыто сейчас • до 00:00',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Museo Sans',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Виджет с кнопками действий.
class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF7BA5B8);
    const primaryColor = Color(0xFFF2EDE4);

    return SizedBox(
      width: 300,
      child: Column(
        children: [
          // Кнопка 1: Забронировать стол (CTA)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Забронировать стол',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Museo Sans',
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Кнопка 2: Меню (Второстепенная)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: accentColor,
                side: const BorderSide(color: accentColor, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Меню',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Museo Sans',
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Кнопка 3: Как добраться (Текстовая)
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: primaryColor.withValues(alpha: 0.7),
            ),
            child: const Text(
              'Как добраться',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                fontFamily: 'Museo Sans',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

