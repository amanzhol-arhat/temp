import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piligrim/data/models/dish.dart';
import 'package:piligrim/data/models/event.dart';
import 'mock_events_repository.dart';
import 'mock_menu_repository.dart';

// Провайдер для меню репозитория
final menuRepositoryProvider = Provider<MockMenuRepository>((ref) {
  return MockMenuRepository();
});

// Провайдер для событий
final eventsRepositoryProvider = Provider<MockEventsRepository>((ref) {
  return MockEventsRepository();
});

// Асинхронные провайдеры для получения данных на Главную
final seasonalDishesProvider = FutureProvider<List<Dish>>((ref) async {
  final repo = ref.read(menuRepositoryProvider);
  return repo.getSeasonalDishes();
});

final todayEventsProvider = FutureProvider<List<Event>>((ref) async {
  final repo = ref.read(eventsRepositoryProvider);
  return repo.getTodayEvents();
});
