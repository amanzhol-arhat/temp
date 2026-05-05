import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_model.dart';

final afishaEventsProvider = Provider<List<EventModel>>((ref) {
  final now = DateTime.now();
  
  return [
    EventModel(
      id: '1',
      title: 'Ритуал звука. Джаз',
      date: DateTime(now.year, now.month, now.day + 1, 20, 0),
      description: 'Живая музыка и специальное сет-меню.',
      format: EventFormat.open,
      price: 'Вход свободный',
      location: 'Ивент-спейс «АУА»',
    ),
    EventModel(
      id: '2',
      title: 'Тайная вечеря. Гастрономическое путешествие',
      date: now.add(const Duration(days: 3)),
      description: 'Эксклюзивная дегустация новых блюд.',
      format: EventFormat.closed,
      price: '15 000 ₸',
      location: 'Ивент-спейс «АУА»',
    ),
    EventModel(
      id: '3',
      title: 'Познание лозы. Винная дегустация',
      date: now.add(const Duration(days: 7)),
      description: 'Разбор локальных вин с сомелье.',
      format: EventFormat.open,
      price: '5 000 ₸',
      location: 'Ивент-спейс «АУА»',
    ),
  ];
});
