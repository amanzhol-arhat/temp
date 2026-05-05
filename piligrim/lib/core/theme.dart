import 'package:flutter/material.dart';

// Raw palette — single source of truth for brand hex values.
// In widgets, prefer Theme.of(context).colorScheme.* over these constants.
class AppColors {
  static const Color earth      = Color(0xFF3D3A38); // Қара жер — scaffold bg → surface
  static const Color sky        = Color(0xFFF2EDE4); // Ақ аспан — main text  → onSurface
  static const Color water      = Color(0xFF7BA5B8); // Мөлдір су — accent    → primary
  static const Color steppe     = Color(0xFFC4956A); // Сары дала — secondary → secondary
  static const Color fruit      = Color(0xFF8B1A1A); // Піскен жеміс — action → tertiary
  static const Color earthDeep  = Color(0xFF2A2826); // Глубокий фон → surfaceContainerLow
}

class AppTheme {
  // Seed colour drives ColorScheme.fromSeed() auto-generation. We override
  // the individual roles below so the output matches the brand palette exactly.
  static const Color _seed = AppColors.water;

  static ThemeData get darkTheme {
    final cs = _buildColorScheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      fontFamily: 'Museo Sans',
      scaffoldBackgroundColor: cs.surface,

      // ── Text scale ──────────────────────────────────────────────────────
      textTheme: TextTheme(
        // Display / Headline — large, bold
        displayLarge:  TextStyle(color: cs.onSurface, fontWeight: FontWeight.w700),
        headlineLarge: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w700),
        headlineMedium:TextStyle(color: cs.onSurface, fontWeight: FontWeight.w700),
        // Title — card headers, section labels
        titleLarge:    TextStyle(color: cs.onSurface, fontWeight: FontWeight.w700),
        titleMedium:   TextStyle(color: cs.onSurface, fontWeight: FontWeight.w700),
        titleSmall:    TextStyle(color: cs.onSurface, fontWeight: FontWeight.w700),
        // Body — paragraphs, descriptions
        bodyLarge:     TextStyle(color: cs.onSurface, fontWeight: FontWeight.w300),
        bodyMedium:    TextStyle(color: cs.onSurface, fontWeight: FontWeight.w300),
        bodySmall:     TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w300),
        // Label — buttons, chips, captions
        labelLarge:    TextStyle(color: cs.onSurface, fontWeight: FontWeight.w700, letterSpacing: 0.1),
        labelMedium:   TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w300),
        labelSmall:    TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w300, letterSpacing: 1.2),
      ),

      // ── Cards — M3 shape-medium = 12dp ──────────────────────────────────
      cardTheme: CardThemeData(
        color: cs.surfaceContainerLow,
        elevation: 0, // M3: elevation via tonal surface, not shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: cs.outlineVariant, width: 1),
        ),
      ),

      // ── Filled button — M3 shape-full = stadium ──────────────────────────
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

      // ── Snackbar — inverse surface per M3 spec ───────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cs.inverseSurface,
        contentTextStyle: TextStyle(color: cs.onInverseSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // ── Bottom navigation bar ────────────────────────────────────────────
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
    // Start from seed so Flutter fills any roles we don't override.
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

      // ── Surface hierarchy — earth tones ──────────────────────────────────
      surface:                    AppColors.earth,       // scaffold фон
      onSurface:                  AppColors.sky,
      onSurfaceVariant:           const Color(0xFFCBBFB5), // приглушённый sky
      surfaceContainerLowest:     const Color(0xFF1A1817),
      surfaceContainerLow:        AppColors.earthDeep,   // карточки, navbar
      surfaceContainer:           const Color(0xFF302D2B),
      surfaceContainerHigh:       const Color(0xFF3B3835),
      surfaceContainerHighest:    const Color(0xFF464240),

      // ── Outlines ─────────────────────────────────────────────────────────
      outline:        const Color(0xFF9D9289), // важные границы (text fields)
      outlineVariant: const Color(0xFF504B47), // декоративные (dividers, card borders)

      // ── Inverse — для snackbar и контрастных элементов ──────────────────
      inverseSurface:   AppColors.sky,
      onInverseSurface: AppColors.earth,
      inversePrimary:   const Color(0xFF3E7A90),

      surfaceTint: AppColors.water,
    );
  }
}
