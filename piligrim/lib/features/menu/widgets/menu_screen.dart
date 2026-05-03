import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../../../data/repositories/providers.dart';
import 'widgets/tiktok_dish_card.dart'; // Импортируем нашу карточку

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allDishesAsync = ref.watch(allDishesProvider);

    return Scaffold(
      backgroundColor: AppColors.earthDeep,
      body: allDishesAsync.when(
        data: (dishes) {
          if (dishes.isEmpty) {
            return const Center(
              child: Text('Меню пусто', style: TextStyle(color: AppColors.sky)),
            );
          }
          // TikTok скролл
          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical, // Вертикальный скролл
            itemCount: dishes.length,
            itemBuilder: (context, index) {
              return TikTokDishCard(dish: dishes[index]);
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.steppe),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Ошибка: $err',
            style: const TextStyle(color: AppColors.sky),
          ),
        ),
      ),
    );
  }
}
