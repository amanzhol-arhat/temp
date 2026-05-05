import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/widgets/floating_totems_background.dart';
import 'providers/afisha_events_provider.dart';
import 'models/event_model.dart';

/// Экран афиши мероприятий ресторана.
class AfishaScreen extends ConsumerWidget {
  const AfishaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(afishaEventsProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF3D3A38),
      appBar: AppBar(
        title: const Text(
          'Афиша',
          style: TextStyle(
            color: Color(0xFFF2EDE4),
            fontFamily: 'Museo Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFF2EDE4)),
      ),
      body: Stack(
        children: [
          // Фоновая анимация тотемов
          const FloatingTotemsBackground(),

          // Основной контент
          SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return _EventCard(
                  event: event,
                  onSignUpPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Удачного пути, герой! Вы записаны на: ${event.title}',
                          style: const TextStyle(color: Color(0xFFF2EDE4)),
                        ),
                        backgroundColor: const Color(0xFF2A2826),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Приватный виджет карточки события.
class _EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onSignUpPressed;

  const _EventCard({required this.event, required this.onSignUpPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2826),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF2EDE4).withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(0, 4),
            blurRadius: 24,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Обложка (Заглушка)
          Container(
            height: 180,
            width: double.infinity,
            color: const Color(0xFF3D3A38),
            child: Center(
              child: SvgPicture.asset(
                'assets/svg/wheel_totem.svg',
                width: 64,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF7BA5B8),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),

          // Информация
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    color: Color(0xFFF2EDE4),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Museo Sans',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_formatDateTime(event.date)} • ${event.location}',
                  style: const TextStyle(
                    color: Color(0xFFC4956A),
                    fontSize: 14,
                    fontFamily: 'Museo Sans',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFFF2EDE4).withOpacity(0.7),
                    fontSize: 14,
                    fontFamily: 'Museo Sans',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      event.format == EventFormat.open
                          ? 'Открытое мероприятие'
                          : 'Закрытое событие',
                      style: const TextStyle(
                        color: Color(0xFF7BA5B8),
                        fontSize: 12,
                        fontFamily: 'Museo Sans',
                      ),
                    ),
                    const Spacer(),
                    if (event.price != null)
                      Text(
                        event.price!,
                        style: const TextStyle(
                          color: Color(0xFFF2EDE4),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Museo Sans',
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: onSignUpPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7BA5B8),
                      foregroundColor: const Color(0xFFF2EDE4),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Записаться',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Museo Sans',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    const months = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря',
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
