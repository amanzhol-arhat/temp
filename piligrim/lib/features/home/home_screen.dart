import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../../data/repositories/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // ─── Бизнес-логика (не трогаем) ──────────────────────────────────────────

  void _callWaiter(BuildContext context, String action) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$action — запрос отправлен',
          style: const TextStyle(
            color: AppColors.steppe,
            fontFamily: 'Museo Sans',
          ),
        ),
        backgroundColor: AppColors.earthDeep,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Официант уже в пути',
              style: TextStyle(color: AppColors.sky, fontFamily: 'Museo Sans'),
            ),
            backgroundColor: AppColors.earthDeep,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seasonalDishesAsync = ref.watch(seasonalDishesProvider);
    final todayEventsAsync = ref.watch(todayEventsProvider);

    return Scaffold(
      backgroundColor: AppColors.earth,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Логотип ────────────────────────────────────────────────────
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

            // ── Сезонное ───────────────────────────────────────────────────
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

            // ── Сегодня в Piligrim ──────────────────────────────────────────
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

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // ── Управление ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _SectionLabel(label: '✦ УПРАВЛЕНИЕ'),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.4,
                children: [
                  _WaiterButton(
                    context: context,
                    onTap: _callWaiter,
                    icon: '✦',
                    label: 'Позвать',
                    action: 'Подойти к столу',
                  ),
                  _WaiterButton(
                    context: context,
                    onTap: _callWaiter,
                    icon: '⬡',
                    label: 'Счёт',
                    action: 'Принести счёт',
                  ),
                  _WaiterButton(
                    context: context,
                    onTap: _callWaiter,
                    icon: '◆',
                    label: 'Вода',
                    action: 'Принести воду',
                  ),
                  _WaiterButton(
                    context: context,
                    onTap: _callWaiter,
                    icon: '✧',
                    label: 'Помощь',
                    action: 'Нужна помощь',
                  ),
                ],
              ),
            ),

            // ── Нижний отступ для TabBar ────────────────────────────────────
            const SliverToBoxAdapter(child: SizedBox(height: 48)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  PRIVATE COMPONENTS
// ═══════════════════════════════════════════════════════════════════════════

/// Заголовок секции — лёгкий, трекинговый, золотистый.
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
          color: AppColors.steppe.withOpacity(0.85),
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
          color: AppColors.sky.withOpacity(0.06),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Изображение — 56 % высоты карточки (≈ 117 px из 210)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Container(
              height: 118,
              color: AppColors.water.withOpacity(0.35),
              child: Center(
                child: Icon(
                  Icons.restaurant,
                  color: AppColors.water.withOpacity(0.5),
                  size: 32,
                ),
              ),
            ),
          ),
          // Текстовый блок — фиксированные внутренние отступы
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
          color: AppColors.steppe.withOpacity(0.18),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Левый акцент-бордер
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
          // Контент
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
                      color: AppColors.sky.withOpacity(0.55),
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

/// Кнопка вызова официанта — иконка + надпись строго по центру.
class _WaiterButton extends StatelessWidget {
  const _WaiterButton({
    required this.context,
    required this.onTap,
    required this.icon,
    required this.label,
    required this.action,
  });

  final BuildContext context;
  final void Function(BuildContext, String) onTap;
  final String icon;
  final String label;
  final String action;

  @override
  Widget build(BuildContext _) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(context, action),
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.steppe.withOpacity(0.12),
        highlightColor: AppColors.steppe.withOpacity(0.06),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.earthDeep,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.sky.withOpacity(0.07),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.16),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  icon,
                  style: const TextStyle(
                    color: AppColors.steppe,
                    fontSize: 14,
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.sky,
                    letterSpacing: 0.4,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Вспомогательные состояния ─────────────────────────────────────────────

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
          color: AppColors.sky.withOpacity(0.4),
          fontSize: 12,
        ),
      ),
    );
  }
}
