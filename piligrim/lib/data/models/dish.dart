// Модель комментария к блюду
class DishComment {
  final String author;
  final int rating; // Оценка от 1 до 5
  final String text;

  DishComment({
    required this.author,
    required this.rating,
    required this.text,
  });
}

// Модель блюда
class Dish {
  final int id;
  final String name;
  final String category;
  final int price;
  final String description;
  final List<String> tags; // Например, ['вегетарианское', 'острое']
  final List<String> allergens;
  final int kcal;
  final int protein;
  final int fat;
  final int carbs;
  final String? imageUrl; // Может быть null, если есть только видео
  final String? videoUrl; // Локальный путь к видео
  final List<DishComment> comments;

  Dish({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.tags,
    required this.allergens,
    required this.kcal,
    required this.protein,
    required this.fat,
    required this.carbs,
    this.imageUrl,
    this.videoUrl,
    required this.comments,
  });
}