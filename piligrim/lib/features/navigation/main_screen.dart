import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import 'package:piligrim/features/home/home_screen.dart';

// Здесь позже будут реальные экраны из фичей
// Пока используем заглушки для проверки навигации
class DummyScreen extends StatelessWidget {
  final String title;
  const DummyScreen(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Список экранов для отображения в зависимости от выбранной вкладки
  final List<Widget> _screens = const [
    HomeScreen(), // Индекс 0
    DummyScreen('Меню'), // Индекс 1
    DummyScreen('Корзина'), // Индекс 2
    DummyScreen('Профиль'), // Индекс 3
  ];

  // Метод для переключения вкладок
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Используем IndexedStack, чтобы сохранять состояние экранов при переключении
      body: IndexedStack(index: _currentIndex, children: _screens),
      // Кастомный нижний бар
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
          bottom: 24,
          top: 12,
        ), // Отступы для SafeArea (челки)
        decoration: BoxDecoration(
          color: AppColors.earthDeep, // Темный фон бара
          border: Border(
            top: BorderSide(
              color: AppColors.sky.withOpacity(0.1), // Тонкий разделитель
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(AppAssets.totemStar, 'Главная', 0),
            _buildNavItem(AppAssets.totemBird, 'Меню', 1),
            _buildNavItem(AppAssets.totemWheel, 'Корзина', 2),
            _buildNavItem(AppAssets.totemMoon, 'Профиль', 3),
          ],
        ),
      ),
    );
  }

  // Виджет отдельной кнопки навигации
  Widget _buildNavItem(String svgPath, String label, int index) {
    final isActive = _currentIndex == index;
    // Активная иконка окрашивается в акцентный цвет (Мөлдір су), неактивная - полупрозрачный текст
    final color = isActive ? AppColors.water : AppColors.sky.withOpacity(0.4);

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque, // Расширяет зону клика
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Анимация масштабирования при переключении
          AnimatedScale(
            scale: isActive ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: SvgPicture.asset(
              svgPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w300,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
