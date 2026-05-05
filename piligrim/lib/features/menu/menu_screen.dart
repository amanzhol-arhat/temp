import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/menu_provider.dart';
import 'widgets/menu_mode_toggle.dart';
import 'widgets/widgets/tiktok_dish_card.dart';
import '../../data/repositories/providers.dart';
import '../../data/models/dish.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(menuViewModeProvider);
    final dishesAsync = ref.watch(allDishesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF2A2826),
      body: Stack(
        children: [
          // Основной контент
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: dishesAsync.when(
              data: (dishes) {
                if (mode == MenuMode.video) {
                  return _VideoMenuFeed(key: const ValueKey('video'), dishes: dishes);
                } else {
                  return _ClassicMenuList(key: const ValueKey('list'), dishes: dishes);
                }
              },
              loading: () => const Center(
                key: ValueKey('loading'),
                child: CircularProgressIndicator(color: Color(0xFFC4956A)),
              ),
              error: (err, stack) => Center(
                key: const ValueKey('error'),
                child: Text('Ошибка: $err', style: const TextStyle(color: Color(0xFFFFFFFF))),
              ),
            ),
          ),

          // Плавающий переключатель
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: const MenuModeToggle(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoMenuFeed extends StatelessWidget {
  final List<Dish> dishes;
  const _VideoMenuFeed({super.key, required this.dishes});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: dishes.length,
      itemBuilder: (context, index) {
        return TikTokDishCard(dish: dishes[index]);
      },
    );
  }
}

class _ClassicMenuList extends StatelessWidget {
  final List<Dish> dishes;
  const _ClassicMenuList({super.key, required this.dishes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 80, bottom: 20),
      itemCount: dishes.length,
      itemBuilder: (context, index) {
        final dish = dishes[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2826),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFFFFFFF).withValues(alpha: 0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 24,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заглушка под фото
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2826),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: Color(0xFFFFFFFF),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              // Информация
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dish.name,
                      style: const TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Museo Sans',
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Теги
                    Wrap(
                      spacing: 8,
                      children: [
                        _SmallTag('${dish.kcal} ккал'),
                        if (dish.tags.isNotEmpty)
                          _SmallTag(dish.tags.first),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${dish.price} ₸',
                      style: const TextStyle(
                        color: Color(0xFFC4956A),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Museo Sans',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SmallTag extends StatelessWidget {
  final String text;
  const _SmallTag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFFFFFFFF).withValues(alpha: 0.5),
          fontSize: 12,
          fontWeight: FontWeight.w300,
          fontFamily: 'Museo Sans',
        ),
      ),
    );
  }
}
