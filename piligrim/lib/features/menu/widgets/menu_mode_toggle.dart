import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'menu_provider.dart';

class MenuModeToggle extends ConsumerWidget {
  const MenuModeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(menuViewModeProvider);
    const primaryColor = Color(0xFFF2EDE4);
    const accentColor = Color(0xFF7BA5B8);
    const backgroundColor = Color(0xFF2A2826);

    return Container(
      height: 40,
      width: 200, // Задаем фиксированную ширину для центрирования
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleItem(
              title: 'Видео',
              isActive: mode == MenuMode.video,
              onTap: () => ref.read(menuViewModeProvider.notifier).state = MenuMode.video,
            ),
          ),
          Expanded(
            child: _ToggleItem(
              title: 'Список',
              isActive: mode == MenuMode.list,
              onTap: () => ref.read(menuViewModeProvider.notifier).state = MenuMode.list,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _ToggleItem({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFF2EDE4);
    const accentColor = Color(0xFF7BA5B8);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? accentColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? primaryColor : primaryColor.withValues(alpha: 0.4),
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w300,
            fontFamily: 'Museo Sans',
          ),
        ),
      ),
    );
  }
}
