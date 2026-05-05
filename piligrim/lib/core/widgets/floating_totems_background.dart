// ignore_for_file: avoid_redundant_argument_values

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // Тикер
import 'package:flutter_svg/flutter_svg.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ПУЛ SVG-РЕСУРСОВ
// ─────────────────────────────────────────────────────────────────────────────

/// 16 пиктограмм тотемов из фирменного набора Piligrim.
/// Исходная папка: assets/svg/
/// Исключены из пула: piligrim.svg (логотип), splash_path.svg, x.svg.
const List<String> _kAssets = [
  'assets/svg/bird_totem.svg',
  'assets/svg/cobyz.svg',
  'assets/svg/luk.svg',
  'assets/svg/moon_totem.svg',
  'assets/svg/pegasus.svg',
  'assets/svg/pegasus1.svg',
  'assets/svg/shaman.svg',
  'assets/svg/spiral.svg',
  'assets/svg/star_totem.svg',
  'assets/svg/stone.svg',
  'assets/svg/sun.svg',
  'assets/svg/tree_totem.svg',
  'assets/svg/wheel_totem.svg',
  'assets/svg/zerno.svg',
];

// ─────────────────────────────────────────────────────────────────────────────
// МОДЕЛЬ ЧАСТИЦЫ
// ─────────────────────────────────────────────────────────────────────────────

/// Состояние одной плавающей иконки тотема.
///
/// Все физические величины используют логические пиксели (x, y) и секунды (скорость,
/// частота). Начало координат находится в левом верхнем углу экрана,
/// y увеличивается вниз — поэтому движение вверх уменьшает y.
class TotemParticle {
  TotemParticle({
    required this.svgPath,
    required this.baseX,
    required this.y,
    required this.speedY,
    required this.ampX,
    required this.freqX,
    required this.phaseX,
    required this.size,
    required this.steadyOpacity,
    required this.screenH,
  })  : x = baseX,      // x начинается с baseX; синус смещает его в каждом кадре
        id = _nextId++; // уникальный идентификатор для сверки виджетов Flutter

  // ── Идентификация ──────────────────────────────────────────────────────────

  /// Автоматически увеличивающийся id, назначаемый при создании.
  /// Используется как [ValueKey] в дереве виджетов, чтобы Flutter правильно сопоставлял
  /// частицы при изменении списка во время анимации.
  static int _nextId = 0;
  final int id;

  // ── Неизменяемые физические константы ──────────────────────────────────────

  /// Путь к SVG-ресурсу для этой частицы.
  final String svgPath;

  /// Координата x, вокруг которой частица колеблется по горизонтали.
  /// Равна начальному положению x; дрейф по синусоиде применяется относительно этого значения.
  final double baseX;

  /// Скорость движения вверх в логических пикселях в секунду.
  /// Чем выше значение, тем меньше времени частица находится на экране.
  final double speedY;

  /// Амплитуда горизонтального синусоидального дрейфа в логических пикселях.
  /// Создает эффект покачивания «уголька на ветру».
  final double ampX;

  /// Угловая частота горизонтального колебания в радианах в секунду.
  /// Большее значение означает более быстрое покачивание из стороны в сторону.
  final double freqX;

  /// Фазовое смещение горизонтального колебания (в радианах).
  /// Рандомизируется при появлении, чтобы каждая частица качалась несинхронно с соседними.
  final double phaseX;

  /// Размер иконки в логических пикселях. Рандомизируется в диапазоне 20–45 пикселей.
  final double size;

  /// Значение прозрачности, используемое в «стабильной» зоне полета
  /// (без затухания или появления). Диапазон: 0.10–0.15 согласно спецификации бренда.
  final double steadyOpacity;

  /// Кэшированная высота экрана, используемая для расчета огибающей прозрачности.
  /// Переиспользуется в каждом кадре.
  final double screenH;

  // ── Изменяемое состояние (обновляется в каждом тике) ────────────────────────

  /// Текущий левый край иконки в логических пикселях.
  double x;

  /// Текущий верхний край иконки в логических пикселях.
  double y;

  // ── Вычисляемые свойства ──────────────────────────────────────────────────

  /// True, если иконка полностью поднялась выше верхней границы экрана.
  /// После этого частица утилизируется, и снизу появляется новая.
  bool get isDead => y + size < 0;

  /// Текущая прозрачность, зависящая от вертикального положения частицы.
  ///
  /// Огибающая прозрачности (на основе нормализованного y ∈ [0, 1]):
  ///   • [0.88 … 1.0] — зона появления (частица входит снизу)
  ///   • [0.28 … 0.88] — стабильная зона (прозрачность по бренду: 0.10–0.15)
  ///   • [0.00 … 0.28] — зона затухания (частица исчезает у верхней границы)
  double get opacity {
    // norm = 1.0, когда частица внизу, 0.0 — вверху.
    final norm = (y / screenH).clamp(0.0, 1.0);

    if (norm > 0.88) {
      // Появление: от 0 до steadyOpacity при входе частицы снизу.
      return ((1.0 - norm) / 0.12) * steadyOpacity;
    }
    if (norm < 0.28) {
      // Затухание: от steadyOpacity до 0 при приближении к верхней трети.
      return (norm / 0.28) * steadyOpacity;
    }

    // Стабильный полет.
    return steadyOpacity;
  }

  // ── Обновление физики ─────────────────────────────────────────────────────

  /// Продвижение частицы на [dt] секунд.
  ///
  /// [totalSec] — накопленное физическое время (ограниченное, не реальное время),
  /// используемое для расчета горизонтального положения по синусоиде.
  void update(double dt, double totalSec) {
    // Движение вверх.
    y -= speedY * dt;

    // Синусоидальный горизонтальный дрейф: имитирует уголек, плывущий на легком ветру.
    x = baseX + ampX * sin(freqX * totalSec + phaseX);
  }

  // ── Фабрики ───────────────────────────────────────────────────────────────

  /// Создает частицу, которая входит на экран снизу.
  ///
  /// Используется для постоянного восполнения частиц после того, как старая частица покинула экран сверху.
  factory TotemParticle.spawn(double screenW, double screenH, Random rng) {
    final size = 20.0 + rng.nextDouble() * 25.0; // 20–45 пикселей

    return TotemParticle(
      svgPath:       _kAssets[rng.nextInt(_kAssets.length)],
      // Ограничиваем зону колебаний в пределах [0, screenW] с помощью baseX.
      baseX:         size + rng.nextDouble() * (screenW - size * 2).clamp(0, screenW),
      // Появление чуть ниже видимой области с небольшим случайным смещением
      // для естественного чередования появления.
      y:             screenH + rng.nextDouble() * 20.0,
      speedY:        16.0 + rng.nextDouble() * 16.0, // 16–32 пикс/с → ~10–20 с на экране
      ampX:          8.0  + rng.nextDouble() * 18.0, // амплитуда колебания 8–26 пикс
      freqX:         0.18 + rng.nextDouble() * 0.32, // частота 0.18–0.50 рад/с
      phaseX:        rng.nextDouble() * 2 * pi,       // случайная начальная фаза
      size:          size,
      steadyOpacity: 0.10 + rng.nextDouble() * 0.05, // 0.10–0.15 (по бренду)
      screenH:       screenH,
    );
  }

  /// Создает частицу в случайной позиции y в любом месте экрана.
  ///
  /// Используется для **начального заполнения**, чтобы анимация выглядела уже запущенной
  /// при первом рендере, а не пустой в течение нескольких секунд.
  factory TotemParticle.seeded(double screenW, double screenH, Random rng) {
    final p = TotemParticle.spawn(screenW, screenH, rng);
    // Рандомизируем y внутри видимой области.
    p.y = rng.nextDouble() * screenH;
    return p;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ВИДЖЕТ
// ─────────────────────────────────────────────────────────────────────────────

/// Полноэкранный анимированный фоновый слой с медленно поднимающимися и плавно дрейфующими
/// иконками тотемов Piligrim.
///
/// Использование:
/// ```dart
/// body: Stack(
///   children: [
///     const IgnorePointer(child: FloatingTotemsBackground()),
///     SafeArea(child: yourContent),
///   ],
/// ),
/// ```
class FloatingTotemsBackground extends StatefulWidget {
  const FloatingTotemsBackground({
    super.key,
    this.particleCount = 20,
  });

  /// Количество частиц тотемов, поддерживаемых одновременно.
  /// Рекомендуемый диапазон 15–25 для баланса плотности и производительности.
  final int particleCount;

  @override
  State<FloatingTotemsBackground> createState() =>
      _FloatingTotemsBackgroundState();
}

class _FloatingTotemsBackgroundState extends State<FloatingTotemsBackground>
    with SingleTickerProviderStateMixin {

  // ── Управление анимацией ──────────────────────────────────────────────────

  /// Тикер, синхронизированный с vsync, который управляет симуляцией частиц.
  /// Автоматически приостанавливается [TickerMode], когда виджет не на экране
  /// (например, скрыт за другим роутом в стеке Navigator).
  late final Ticker _ticker;

  // ── Тайминг ───────────────────────────────────────────────────────────────

  /// Время, прошедшее с момента последнего вызова [_onTick].
  /// Используется для расчета необработанной разницы времени между кадрами.
  Duration _lastElapsed = Duration.zero;

  /// Накопленное физическое время в секундах, увеличивающееся на **ограниченное** dt.
  ///
  /// Намеренно отделено от реального времени, чтобы большой разрыв в
  /// вызовах vsync (пауза тикера при навигации) не приводил к резкому
  /// прыжку горизонтального положения синусоиды при возобновлении.
  double _totalSec = 0.0;

  // ── Частицы ───────────────────────────────────────────────────────────────

  final List<TotemParticle> _particles = [];
  final _rng = Random();

  // ── Слой (Layout) ──────────────────────────────────────────────────────────

  /// Кэшированный размер виджета, полученный из [LayoutBuilder] во время [build].
  /// Тикер считывает его на следующем vsync.
  Size _size = Size.zero;

  // ── Жизненный цикл ─────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    // Запускаем тикер немедленно; он ничего не будет делать, пока _size не станет известен.
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    // Удаление тикера отменяет регистрацию vsync и останавливает обратные вызовы.
    _ticker.dispose();
    super.dispose();
  }

  // ── Обработчик тиков ──────────────────────────────────────────────────────

  void _onTick(Duration elapsed) {
    // ── Расчет дельты времени (dt) ───────────────────────────────────────
    final rawDt = (elapsed - _lastElapsed).inMicroseconds / 1e6;

    // Всегда обновляем _lastElapsed истинным значением, чтобы rawDt следующего
    // кадра был относительно правильной базы, даже если мы ограничиваем текущий.
    _lastElapsed = elapsed;

    // ── ИСПРАВЛЕНИЕ: ограничение dt ──────────────────────────────────────
    double dt = rawDt;
    if (dt <= 0.0 || dt > 0.05) {
      dt = 0.016; // Запасной вариант для 60 FPS
    }

    // Увеличиваем физическое время на **ограниченное** dt, а не на реальное время.
    // Это сохраняет стабильность горизонтального положения синусоиды после пауз.
    _totalSec += dt;

    // ── Проверка: пропускаем физику, пока размер неизвестен ──────────────
    if (_size == Size.zero) return;

    setState(() {
      // ── Обновление физики ─────────────────────────────────────────────
      for (final p in _particles) {
        p.update(dt, _totalSec);
      }

      // ── Утилизация «мертвых» частиц ────────────────────────────────────
      // Удаляем частицы, которые полностью покинули экран сверху.
      _particles.removeWhere((p) => p.isDead);

      // Добавляем новые частицы снизу для поддержания целевой плотности.
      while (_particles.length < widget.particleCount) {
        _particles.add(
          TotemParticle.spawn(_size.width, _size.height, _rng),
        );
      }
    });
  }

  // ── Рендеринг ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight == 0) {
          return const SizedBox.shrink();
        }

        // Сохраняем текущий размер виджета для использования тикером.
        // Это простое присваивание поля (не setState), что безопасно в build.
        _size = constraints.biggest;

        if (_particles.isEmpty) {
          for (int i = 0; i < widget.particleCount; i++) {
            _particles.add(
              TotemParticle.seeded(constraints.maxWidth, constraints.maxHeight, _rng),
            );
          }
        }

        return Stack(
          // Обрезаем частицы, которые выходят за границы виджета (например, при колебаниях).
          clipBehavior: Clip.hardEdge,
          children: [
            for (final p in _particles)
              _ParticleWidget(
                key: ValueKey(p.id),
                particle: p,
              ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ВИДЖЕТ ЧАСТИЦЫ
// ─────────────────────────────────────────────────────────────────────────────

/// Отрисовывает одну [TotemParticle] как позиционированную SVG-иконку с оттенком.
///
/// Использование отдельного класса виджета (вместо инлайнового билдера) делает список
/// детей Stack более читаемым и позволяет Flutter использовать [ValueKey] для эффективной сверки.
class _ParticleWidget extends StatelessWidget {
  const _ParticleWidget({super.key, required this.particle});

  final TotemParticle particle;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      // particle.x — это горизонтальный центр иконки; смещаем на половину размера,
      // чтобы преобразовать в координату левого края Positioned.
      left: particle.x - particle.size / 2,
      top:  particle.y,
      child: SvgPicture.asset(
        particle.svgPath,
        width:  particle.size,
        height: particle.size,
        // Кодируем прозрачность напрямую в ColorFilter вместо использования виджета Opacity.
        // Opacity создает слой композиции (saveLayer), что дает нагрузку на GPU.
        // ColorFilter.mode применяется при отрисовке SVG без дополнительных затрат.
        colorFilter: ColorFilter.mode(
          // Фирменный цвет неба #F2EDE4 с вычисленной прозрачностью.
          Color(0xFFF2EDE4).withOpacity(particle.opacity.clamp(0.0, 1.0)),
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
