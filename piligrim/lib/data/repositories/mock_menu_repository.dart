import '../models/dish.dart';

class MockMenuRepository {
  Future<List<Dish>> getDishes() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      Dish(
        id: 1,
        name: 'Тыквенный крем-суп',
        category: 'Супы',
        price: 4200,
        description: 'Нежный крем-суп из запечённой тыквы с трюфельным маслом и тыквенными семечками',
        tags: ['вегетарианское'],
        allergens: ['глютен'],
        kcal: 180,
        protein: 4,
        fat: 9,
        carbs: 22,
        imageUrl: 'assets/images/pumpkin_soup.png',
        videoUrl: 'assets/videos/2026-02-12 16.39.35.mp4',
      ),
      Dish(
        id: 3,
        name: 'Салат Цезарь',
        category: 'Салаты',
        price: 4800,
        description: 'Романо, пармезан 24 месяца выдержки, анчоусы, домашние крутоны',
        tags: [],
        allergens: ['глютен', 'молоко'],
        kcal: 320,
        protein: 15,
        fat: 22,
        carbs: 16,
        videoUrl: 'assets/videos/IMG_4035.mp4',
      ),
      Dish(
        id: 4,
        name: 'Сезонный салат дня',
        category: 'Салаты',
        price: 3900,
        description: 'Микс зелени с инжиром, козьим сыром и медовой заправкой',
        tags: ['вегетарианское'],
        allergens: ['молоко'],
        kcal: 240,
        protein: 8,
        fat: 16,
        carbs: 18,
        videoUrl: 'assets/videos/IMG_4036.mp4',
      ),
      Dish(
        id: 5,
        name: 'Стейк Рибай',
        category: 'Горячее',
        price: 14500,
        description: 'Мраморная говядина 300г на гриле с овощами и соусом демиглас',
        tags: [],
        allergens: [],
        kcal: 580,
        protein: 48,
        fat: 42,
        carbs: 2,
        videoUrl: 'assets/videos/IMG_4037.mp4',
      ),
      Dish(
        id: 13,
        name: 'Cabernet Sauvignon',
        category: 'Вино',
        price: 8500,
        description: 'Чили, 2021 — нотки чёрной смородины и дуба',
        tags: [],
        allergens: ['сульфиты'],
        kcal: 85,
        protein: 0,
        fat: 0,
        carbs: 4,
        videoUrl: 'assets/videos/2026-02-12 16.39.35.mp4',
      ),
    ];
  }

  Future<List<Dish>> getSeasonalDishes() async {
    final allDishes = await getDishes();
    return allDishes.where((dish) => [1, 4, 13].contains(dish.id)).toList();
  }
}
