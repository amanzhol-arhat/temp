/// Модель истории бронирования столов (Странствия героя).
/// Отражает статус и параметры состоявшихся или запланированных визитов.
class BookingModel {
  /// Уникальный идентификатор брони
  final String id;
  
  /// Дата и время визита
  final DateTime date;
  
  /// Количество гостей
  final int guests;
  
  /// Текущий статус брони (например, 'Подтверждена', 'Завершена')
  final String status;

  const BookingModel({
    required this.id,
    required this.date,
    required this.guests,
    required this.status,
  });
}
