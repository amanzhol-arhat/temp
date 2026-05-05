import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Провайдер текущего индекса навигации.
/// 0 - Главная, 1 - Меню, 2 - Интерьер, 3 - Афиша, 4 - Профиль.
final navigationIndexProvider = StateProvider<int>((ref) => 0);
