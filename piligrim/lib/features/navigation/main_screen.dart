import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piligrim/features/menu/menu_screen.dart';
import 'package:piligrim/features/navigation/navigation_provider.dart';
import '../../core/constants.dart';
import '../../core/widgets/floating_totems_background.dart';
import 'package:piligrim/features/home/home_screen.dart';
import 'package:piligrim/features/afisha/afisha_screen.dart';
import 'package:piligrim/features/profile/profile_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ЭКРАН-ЗАГЛУШКА
// ─────────────────────────────────────────────────────────────────────────────

/// Экран-заглушка для вкладок, которые еще находятся в разработке.
///
/// [withBackground] определяет, будет ли анимированный фон [FloatingTotemsBackground]
/// отрисовываться за контентом.
///
/// Включайте для экранов, передающих атмосферу «путешествия» бренда:
///   • Афиша  (Events) — мистический, событийный тон
///   • Профиль (Profile) — личные хроники, «история героя»
///
/// Отключайте для нейтральных контентных экранов (например, Интерьер), где анимация
/// будет отвлекать от фото-контента.
class _DummyScreen extends StatelessWidget {
  const _DummyScreen(this.title, {this.withBackground = false});

  /// Заголовок экрана, отображаемый в центре заглушки.
  final String title;

  /// Нужно ли отрисовывать [FloatingTotemsBackground] в качестве нижнего слоя.
  final bool withBackground;

  @override
  Widget build(BuildContext context) {
    // Центрированный заголовок — контент заглушки для незавершенных экранов.
    final body = Center(
      child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
    );

    return Scaffold(
      // Используем ColorScheme.surface, чтобы фон соответствовал теме M3
      // и был согласован с HomeScreen.
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: withBackground
          // Атмосферный вариант: анимация частиц за текстом заглушки.
          ? Stack(
              children: [
                // ── Нижний слой: фоновая анимация тотемов ───────────────────
                // IgnorePointer предотвращает перехват нажатий анимацией,
                // предназначенных для контента выше.
                const IgnorePointer(child: FloatingTotemsBackground()),
                // ── Верхний слой: контент экрана ────────────────────────────
                body,
              ],
            )
          // Простой вариант: без анимации, только фон scaffold.
          : body,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ГЛАВНЫЙ ЭКРАН (хост вкладок)
// ─────────────────────────────────────────────────────────────────────────────

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  /// Пять экранов вкладок, размещенных внутри [IndexedStack].
  static const List<Widget> _screens = [
    const HomeScreen(), // 0 — Главная
    const MenuScreen(), // 1 — Меню
    const _DummyScreen('Интерьер'), // 2 — без фона
    const AfishaScreen(), // 3 — Афиша
    const ProfileScreen(), // 4 — Профиль
  ];

  /// Элементы навигационной панели: путь к иконке + подпись.
  static const List<({String asset, String label})> _navItems = [
    (asset: AppAssets.totemStar, label: 'Главная'),
    (asset: AppAssets.totemBird, label: 'Меню'),
    (asset: AppAssets.totemTree, label: 'Интерьер'),
    (asset: AppAssets.totemWheel, label: 'Афиша'),
    (asset: AppAssets.totemMoon, label: 'Профиль'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final currentIndex = ref.watch(navigationIndexProvider);

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _screens),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(0),
        child: Container(
          padding: const EdgeInsets.only(bottom: 24, top: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2826),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _navItems.length,
              (i) => _NavItem(
                asset: _navItems[i].asset,
                label: _navItems[i].label,
                isActive: currentIndex == i,
                onTap: () =>
                    ref.read(navigationIndexProvider.notifier).state = i,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ЭЛЕМЕНТ НАВИГАЦИИ
// ─────────────────────────────────────────────────────────────────────────────

/// Одна вкладка нижней навигации: SVG-иконка тотема + подпись.
///
/// Активное состояние: иконка немного увеличивается (×1.1) и использует [ColorScheme.primary].
/// Неактивное состояние: иконка обычного размера, [ColorScheme.onSurface] с прозрачностью 38%.
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.asset,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  /// Путь к SVG-ресурсу для иконки тотема.
  final String asset;

  /// Текст подписи под иконкой (отрисовывается в верхнем регистре).
  final String label;

  /// Выбрана ли эта вкладка в данный момент.
  final bool isActive;

  /// Вызывается, когда пользователь нажимает на этот элемент вкладки.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Активный: основной цвет (#7BA5B8 water).
    // Неактивный: Ақ аспан с прозрачностью 40%
    final color = isActive
        ? Colors.white
        : Colors.white.withValues(alpha: 0.4);

    return GestureDetector(
      onTap: onTap,
      // opaque гарантирует, что вся область колонки (включая промежутки) будет кликабельной,
      // а не только пиксели иконки и текста.
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Легкая анимация масштабирования при активации — спецификация бренда: 200 мс.
          AnimatedScale(
            scale: isActive ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: SvgPicture.asset(
              asset,
              width: 24,
              height: 24,
              // Перекрашиваем монохромный SVG в вычисленный цвет состояния.
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            // Верхний регистр согласно стилю подписей бренда.
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: color,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w300,
              // labelSmall уже имеет letterSpacing: 1.2 из темы.
            ),
          ),
        ],
      ),
    );
  }
}
