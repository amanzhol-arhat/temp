enum EventFormat { open, closed }

class EventModel {
  final String id;
  final String title;
  final DateTime date;
  final String description;
  final EventFormat format;
  final String? price;
  final String? imageUrl;
  final String location;

  EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.format,
    this.price,
    this.imageUrl,
    required this.location,
  });
}
