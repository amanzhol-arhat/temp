import 'package:flutter/material.dart';

// Исходная палитра — единый источник истины для HEX-значений бренда.
// В виджетах предпочтительно использовать Theme.of(context).colorScheme.* вместо этих констант.
class AppColors {
  static const Color earth      = Color(0xFF2A2826); // Қара жер — фон scaffold → surface
  static const Color sky        = Color(0xFFFFFFFF); // Ақ аспан — основной текст → onSurface
  static const Color water      = Color(0xFF7BA5B8); // Мөлдір су — акцент → primary
  static const Color steppe     = Color(0xFFC4956A); // Сары дала — вторичный → secondary
  static const Color fruit      = Color(0xFF8B1A1A); // Піскен жеміс — действие → tertiary
  static const Color earthDeep  = Color(0xFF2A2826); // Глубокий фон → surfaceContainerLow
}

class AppTheme {
  // Базовый цвет управляет автогенерацией ColorScheme.fromSeed(). 
  // Мы переопределяем отдельные роли ниже, чтобы результат точно соответствовал палитре бренда.
  static const Color _seed = AppColors.water;

  static ThemeData get darkTheme {
    final cs = _buildColorScheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      fontFamily: 'Museo Sans',
      scaffoldBackgroundColor: cs.surface,

      // ── Масштабирование текста ──────────────────────────────────────────
      textTheme: TextTheme(
        // Display / Headline — крупный, жирный
        displayLarge:  TextStyle(color: cs.onSurface, fontWeight: FontWeight.w700),
        headlineLarge: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w700),
        headlineMedium:TextStyle(color: cs.onSurface, fontWeight: FontWeight.w700),
        // Title — заголовки карточек, меток разделов
        titleLarge:    TextStyle(color: cs.onSurface, fontWeight: FontWeight.w700),
        titleMedium:   TextStyle(color: cs.onSurface, fontWeight: FontWeight.w700),
        titleSmall:    TextStyle(color: cs.onSurface, fontWeight: FontWeight.w700),
        // Body — параграфы, описания
        bodyLarge:     TextStyle(color: cs.onSurface, fontWeight: FontWeight.w300),
        bodyMedium:    TextStyle(color: cs.onSurface, fontWeight: FontWeight.w300),
        bodySmall:     TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w300),
        // Label — кнопки, чипы, подписи
        labelLarge:    TextStyle(color: cs.onSurface, fontWeight: FontWeight.w700, letterSpacing: 0.1),
        labelMedium:   TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w300),
        labelSmall:    TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w300, letterSpacing: 1.2),
      ),

      // ── Карточки — M3 shape-medium = 12dp ───────────────────────────────
      cardTheme: CardThemeData(
        color: cs.surfaceContainerLow,
        elevation: 0, // M3: возвышение через тональную поверхность, а не тень
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: cs.outlineVariant, width: 1),
        ),
      ),

      // ── Заполненная кнопка — M3 shape-full = stadium ─────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          elevation: 0,
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontFamily: 'Museo Sans',
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),

      // ── Snackbar — инвертированная поверхность согласно спецификации M3 ───
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cs.inverseSurface,
        contentTextStyle: TextStyle(color: cs.onInverseSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // ── Нижняя панель навигации ─────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cs.surfaceContainerLow,
        indicatorColor: cs.primary.withValues(alpha: 0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: cs.primary);
          }
          return IconThemeData(color: cs.onSurfaceVariant);
        }),
      ),
    );
  }

  static ColorScheme _buildColorScheme() {
    // Начинаем с базового цвета, чтобы Flutter заполнил все роли, которые мы не переопределяем.
    final base = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    );

    return base.copyWith(
      // ── Primary — water (акцент, кнопки, активные состояния) ────────────
      primary:            AppColors.water,
      onPrimary:          AppColors.earthDeep,
      primaryContainer:   const Color(0xFF2E5465), // затемнённый water
      onPrimaryContainer: AppColors.sky,

      // ── Secondary — steppe (цены, теги, бордеры событий) ────────────────
      secondary:            AppColors.steppe,
      onSecondary:          AppColors.earthDeep,
      secondaryContainer:   const Color(0xFF5C4328), // затемнённый steppe
      onSecondaryContainer: AppColors.sky,

      // ── Tertiary — fruit (деструктивные / выделяющие действия) ──────────
      tertiary:            AppColors.fruit,
      onTertiary:          AppColors.sky,
      tertiaryContainer:   const Color(0xFF4A0D0D), // затемнённый fruit
      onTertiaryContainer: AppColors.sky,

      // ── Иерархия поверхностей — земляные тона ───────────────────────────
      surface:                    AppColors.earth,       // фон scaffold
      onSurface:                  AppColors.sky,
      onSurfaceVariant:           const Color(0xFFCBBFB5), // приглушённый sky
      surfaceContainerLowest:     const Color(0xFF1A1817),
      surfaceContainerLow:        AppColors.earthDeep,   // карточки, navbar
      surfaceContainer:           const Color(0xFF302D2B),
      surfaceContainerHigh:       const Color(0xFF3B3835),
      surfaceContainerHighest:    const Color(0xFF464240),

      // ── Контуры ────────────────────────────────────────────────────────
      outline:        const Color(0xFF9D9289), // важные границы (текстовые поля)
      outlineVariant: const Color(0xFF504B47), // декоративные (разделители, границы карточек)

      // ── Инверсия — для snackbar и контрастных элементов ─────────────────
      inverseSurface:   AppColors.sky,
      onInverseSurface: AppColors.earth,
      inversePrimary:   const Color(0xFF3E7A90),

      surfaceTint: AppColors.water,
    );
  }
}
