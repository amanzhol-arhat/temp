import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/push_settings.dart';
import '../models/booking_model.dart';

/// Управление настройками уведомлений профиля.
/// Позволяет герою настраивать получение пушей.
class PushSettingsNotifier extends StateNotifier<PushSettings> {
  PushSettingsNotifier() : super(const PushSettings());

  void toggleEvents() {
    state = state.copyWith(events: !state.events);
  }

  void togglePromotions() {
    state = state.copyWith(promotions: !state.promotions);
  }

  void toggleClosedEvents() {
    state = state.copyWith(closedEvents: !state.closedEvents);
  }
}

/// Провайдер текущих настроек уведомлений
final pushSettingsProvider = StateNotifierProvider<PushSettingsNotifier, PushSettings>((ref) {
  return PushSettingsNotifier();
});

/// Провайдер истории бронирований (Летопись странствий героя)
/// Сейчас использует моковые данные для демонстрации.
final bookingHistoryProvider = Provider<List<BookingModel>>((ref) {
  final now = DateTime.now();
  
  return [
    BookingModel(
      id: '1',
      date: DateTime(now.year, now.month, now.day + 1, 19, 0),
      guests: 2,
      status: 'Подтверждена',
    ),
    BookingModel(
      id: '2',
      date: now.subtract(const Duration(days: 7)),
      guests: 4,
      status: 'Завершена',
    ),
  ];
});
