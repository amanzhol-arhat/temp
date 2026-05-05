/// Модель настроек push-уведомлений профиля героя.
/// Позволяет управлять подписками на различные типы информации.
class PushSettings {
  /// Уведомления об общих мероприятиях ("АУА")
  final bool events;
  
  /// Уведомления об акциях и новых блюдах в меню
  final bool promotions;
  
  /// Уведомления о закрытых и эксклюзивных событиях
  final bool closedEvents;

  const PushSettings({
    this.events = true,
    this.promotions = true,
    this.closedEvents = true,
  });

  PushSettings copyWith({
    bool? events,
    bool? promotions,
    bool? closedEvents,
  }) {
    return PushSettings(
      events: events ?? this.events,
      promotions: promotions ?? this.promotions,
      closedEvents: closedEvents ?? this.closedEvents,
    );
  }
}
