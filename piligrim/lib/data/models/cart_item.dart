import 'dish.dart';

// Модель элемента в корзине
class CartItem {
  final Dish dish;
  int quantity;

  CartItem({
    required this.dish,
    this.quantity = 1,
  });
}