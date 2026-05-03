// Модель события (мероприятия)
class Event {
  final String time; // Например, '19:00' или 'Весь вечер'
  final String title;
  final String description;

  Event({
    required this.time,
    required this.title,
    required this.description,
  });
}