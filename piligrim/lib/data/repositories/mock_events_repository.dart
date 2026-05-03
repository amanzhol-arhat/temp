import '../models/event.dart';

class MockEventsRepository {
  // Имитация получения событий дня
  Future<List<Event>> getTodayEvents() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return [
      Event(
        time: '19:00',
        title: 'Jazz trio',
        description: 'Атмосферный джаз в исполнении трио Soul Notes',
      ),
      Event(
        time: '20:30',
        title: 'Шеф-ужин',
        description: 'Специальное меню от шефа с винной парой',
      ),
      Event(
        time: 'Весь вечер',
        title: 'Акустика',
        description: 'Гитара и вокал — любимые хиты',
      ),
    ];
  }
}