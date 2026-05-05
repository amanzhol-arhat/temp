import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piligrim/features/menu/widgets/menu_screen.dart';
import '../../core/constants.dart';
import '../../core/widgets/floating_totems_background.dart';
import 'package:piligrim/features/home/home_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PLACEHOLDER SCREEN
// ─────────────────────────────────────────────────────────────────────────────

/// Placeholder screen used for tabs that are still under development.
///
/// [withBackground] controls whether the [FloatingTotemsBackground] particle
/// animation is rendered behind the content.
///
/// Enable for screens that share the brand's atmospheric "journey" feel:
///   • Афиша  (Events)  — mystical, event-space tone
///   • Профиль (Profile) — personal chronicle, "hero's story"
///
/// Disable for neutral content screens (e.g. Интерьер) where the animation
/// would compete with photo-heavy material.
class _DummyScreen extends StatelessWidget {
  const _DummyScreen(
    this.title, {
    this.withBackground = false,
  });

  /// Screen title shown in the centre of the placeholder.
  final String title;

  /// Whether to render [FloatingTotemsBackground] as the bottom layer.
  final bool withBackground;

  @override
  Widget build(BuildContext context) {
    // Centred title — the placeholder content for unfinished screens.
    final body = Center(
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );

    return Scaffold(
      // Use ColorScheme.surface so the background matches the M3 theme
      // and is consistent with HomeScreen.
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: withBackground
          // Atmospheric variant: particle animation behind placeholder text.
          ? Stack(
              children: [
                // ── Bottom layer: ambient totem animation ─────────────────
                // IgnorePointer prevents the animation from absorbing taps
                // intended for content above it.
                const IgnorePointer(
                  child: FloatingTotemsBackground(),
                ),
                // ── Top layer: screen content ─────────────────────────────
                body,
              ],
            )
          // Plain variant: no animation, just the scaffold background.
          : body,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN SCREEN (tab host)
// ─────────────────────────────────────────────────────────────────────────────

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  /// Index of the currently visible tab (0-based).
  int _currentIndex = 0;

  /// The five tab screens mounted inside [IndexedStack].
  ///
  /// [IndexedStack] keeps all children in memory, so each screen preserves
  /// its state (scroll position, animation) when switching tabs.
  ///
  /// FloatingTotemsBackground screens:
  ///   ✔ Главная   — background managed inside HomeScreen itself
  ///   ✘ Меню      — full-screen video cards; background not applicable
  ///   ✘ Интерьер  — photo-heavy content; plain background
  ///   ✔ Афиша     — events space "АУА"; atmospheric tone
  ///   ✔ Профиль   — hero's chronicle; atmospheric tone
  static const List<Widget> _screens = [
    HomeScreen(),                                           // 0 — Главная
    MenuScreen(),                                          // 1 — Меню
    _DummyScreen('Интерьер'),                              // 2 — no background
    _DummyScreen('Афиша',   withBackground: true),         // 3 — atmospheric
    _DummyScreen('Профиль', withBackground: true),         // 4 — atmospheric
  ];

  /// Navigation bar items: icon asset path + display label.
  /// Order must match [_screens].
  static const List<({String asset, String label})> _navItems = [
    (asset: AppAssets.totemStar,  label: 'Главная'),
    (asset: AppAssets.totemBird,  label: 'Меню'),
    (asset: AppAssets.totemTree,  label: 'Интерьер'),
    (asset: AppAssets.totemWheel, label: 'Афиша'),
    (asset: AppAssets.totemMoon,  label: 'Профиль'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      // IndexedStack renders all children but shows only the active one.
      // This preserves each screen's state (scroll, animation tickers, etc.)
      // across tab switches without reinitialising widgets.
      body: IndexedStack(index: _currentIndex, children: _screens),

      // ── Custom bottom navigation bar ─────────────────────────────────────
      // Built from scratch with totem SVG icons instead of Flutter's default
      // NavigationBar, per Piligrim brand spec (no standard tab bar shapes).
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 24, top: 12),
        decoration: BoxDecoration(
          // surfaceContainerLow matches the theme's deep earth tone (#2A2826).
          color: cs.surfaceContainerLow,
          border: Border(
            top: BorderSide(
              // Subtle top divider — brand spec: rgba(#F2EDE4, 0.08)
              color: cs.onSurface.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            _navItems.length,
            (i) => _NavItem(
              asset:    _navItems[i].asset,
              label:    _navItems[i].label,
              isActive: _currentIndex == i,
              // setState triggers IndexedStack to display the tapped screen.
              onTap: () => setState(() => _currentIndex = i),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NAV ITEM
// ─────────────────────────────────────────────────────────────────────────────

/// A single bottom-nav tab: totem SVG icon + label.
///
/// Active state: icon scales up slightly (×1.1) and uses [ColorScheme.primary].
/// Inactive state: icon at normal scale, [ColorScheme.onSurface] at 38% alpha.
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.asset,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  /// SVG asset path for the totem icon.
  final String asset;

  /// Label text displayed below the icon (rendered in uppercase).
  final String label;

  /// Whether this tab is the currently selected one.
  final bool isActive;

  /// Called when the user taps this tab item.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Active: primary colour (#7BA5B8 water).
    // Inactive: onSurface at 38% — M3 unselected-icon opacity token.
    final color = isActive
        ? cs.primary
        : cs.onSurface.withValues(alpha: 0.38);

    return GestureDetector(
      onTap: onTap,
      // opaque ensures the full column area (including gaps) is tappable,
      // not just the icon and text pixels.
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Subtle scale animation on activation — brand spec: 200 ms.
          AnimatedScale(
            scale:    isActive ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: SvgPicture.asset(
              asset,
              width:  24,
              height: 24,
              // Tint the monochrome SVG with the computed state colour.
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            // Uppercase per brand spec label style.
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color:      color,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w300,
              // labelSmall already has letterSpacing: 1.2 from the theme.
            ),
          ),
        ],
      ),
    );
  }
}
