class Dish {
  final int id;
  final String name;
  final String category;
  final int price;
  final String description;
  final List<String> tags;
  final List<String> allergens;
  final int kcal;
  final int protein;
  final int fat;
  final int carbs;
  final String? imageUrl;
  final String? videoUrl;

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
  });
}
