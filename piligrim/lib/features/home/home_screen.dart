import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../../core/widgets/floating_totems_background.dart';
import '../../data/repositories/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seasonalDishesAsync = ref.watch(seasonalDishesProvider);
    final todayEventsAsync = ref.watch(todayEventsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          const IgnorePointer(child: FloatingTotemsBackground()),
          SafeArea(
            child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Логотип ──────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                child: SvgPicture.asset(
                  AppAssets.logo,
                  height: 26,
                  colorFilter: const ColorFilter.mode(
                    AppColors.sky,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),

            // ── Сезонное ─────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _SectionLabel(label: '✦ СЕЗОННОЕ'),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 210,
                child: seasonalDishesAsync.when(
                  data: (dishes) => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: dishes.length,
                    itemBuilder: (context, index) {
                      final dish = dishes[index];
                      return _SeasonalCard(dish: dish);
                    },
                  ),
                  loading: () => const _LoadingIndicator(),
                  error: (err, stack) => _ErrorLabel(message: '$err'),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // ── Сегодня в Piligrim ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _SectionLabel(label: '✦ СЕГОДНЯ В PILIGRIM'),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 130,
                child: todayEventsAsync.when(
                  data: (events) => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return _EventCard(event: event);
                    },
                  ),
                  loading: () => const _LoadingIndicator(),
                  error: (err, stack) => _ErrorLabel(message: '$err'),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 48)),
          ],
        ),
      ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  PRIVATE COMPONENTS
// ═══════════════════════════════════════════════════════════════════════════

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: AppColors.steppe.withValues(alpha: 0.85),
          letterSpacing: 2.4,
          fontWeight: FontWeight.w400,
          fontFamily: 'Museo Sans',
        ),
      ),
    );
  }
}

/// Карточка сезонного блюда — изображение 56 % высоты, текст 44 %.
class _SeasonalCard extends StatelessWidget {
  const _SeasonalCard({required this.dish});
  final dynamic dish;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.earthDeep,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.sky.withValues(alpha: 0.06),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Container(
              height: 118,
              color: AppColors.water.withValues(alpha: 0.35),
              child: Center(
                child: Icon(
                  Icons.restaurant,
                  color: AppColors.water.withValues(alpha: 0.5),
                  size: 32,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dish.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.sky,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${dish.price} ₸',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.steppe,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Карточка события — горизонтальный акцент-бордер слева.
class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});
  final dynamic event;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.earthDeep,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.steppe.withValues(alpha: 0.18),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            decoration: const BoxDecoration(
              color: AppColors.steppe,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    event.time,
                    style: const TextStyle(
                      color: AppColors.steppe,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.6,
                    ),
                  ),
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.sky,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    event.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.sky.withValues(alpha: 0.55),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Вспомогательные состояния ──────────────────────────────────────────────

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.steppe,
        strokeWidth: 1.5,
      ),
    );
  }
}

class _ErrorLabel extends StatelessWidget {
  const _ErrorLabel({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Ошибка: $message',
        style: TextStyle(
          color: AppColors.sky.withValues(alpha: 0.4),
          fontSize: 12,
        ),
      ),
    );
  }
}
