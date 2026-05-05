import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/profile_providers.dart';
import 'models/booking_model.dart';

/// Экран профиля пользователя (Летопись героя).
/// Здесь отображается информация о герое, история его странствий (бронирований)
/// и настройки уведомлений.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Получаем историю бронирований и настройки уведомлений из провайдеров
    final bookings = ref.watch(bookingHistoryProvider);
    final pushSettings = ref.watch(pushSettingsProvider);
    final pushNotifier = ref.read(pushSettingsProvider.notifier);

    // Цвета из дизайн-системы
    const backgroundColor = Color(0xFF2A2826); // Қара жер
    const cardColor = Color(0xFF2A2826);       // Тёмный фон контейнеров
    const accentColor = Color(0xFF7BA5B8);     // Мөлдір су (Акцент)
    const textColor = Color(0xFFFFFFFF);       // Ақ аспан (Светлый текст)
    const fontFamily = 'Museo Sans';

    return Scaffold(
      backgroundColor: backgroundColor,
      // Оборачиваем в SafeArea, чтобы контент не уходил под статус-бар ("сильно вверх ушел")
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
          // Секция "Герой"
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: cardColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: accentColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Анонимный герой',
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Телефон не привязан',
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 14,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Секция "История пути"
          const Text(
            'История бронирований',
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final isConfirmed = booking.status == 'Подтверждена';
              
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${booking.date.day.toString().padLeft(2, '0')}.${booking.date.month.toString().padLeft(2, '0')}.${booking.date.year} ${booking.date.hour.toString().padLeft(2, '0')}:${booking.date.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontFamily: fontFamily,
                        color: textColor,
                      ),
                    ),
                    Text(
                      booking.status,
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w700,
                        color: isConfirmed ? accentColor : textColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // Секция "Связь"
          const Text(
            'Уведомления',
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          _NotificationSwitch(
            label: 'Мероприятия',
            value: pushSettings.events,
            onChanged: (_) => pushNotifier.toggleEvents(),
          ),
          _NotificationSwitch(
            label: 'Акции и предложения',
            value: pushSettings.promotions,
            onChanged: (_) => pushNotifier.togglePromotions(),
          ),
          _NotificationSwitch(
            label: 'Закрытые события',
            value: pushSettings.closedEvents,
            onChanged: (_) => pushNotifier.toggleClosedEvents(),
          ),
        ],
        ),
      ),
    );
  }
}

class _NotificationSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationSwitch({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Museo Sans',
          fontSize: 14,
          color: Color(0xFFFFFFFF),
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF7BA5B8),
      inactiveTrackColor: const Color(0xFF2A2826),
      contentPadding: EdgeInsets.zero,
    );
  }
}
