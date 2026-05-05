// ignore_for_file: avoid_redundant_argument_values

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // Ticker
import 'package:flutter_svg/flutter_svg.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SVG ASSET POOL
// ─────────────────────────────────────────────────────────────────────────────

/// 16 totem pictograms from the Piligrim brand set.
/// Source folder: assets/svg/
/// Excluded from the pool: piligrim.svg (logo), splash_path.svg, x.svg.
const List<String> _kAssets = [
  'assets/svg/assyki.svg',
  'assets/svg/bird_totem.svg',
  'assets/svg/cobyz.svg',
  'assets/svg/luk.svg',
  'assets/svg/moon_totem.svg',
  'assets/svg/pegasus.svg',
  'assets/svg/pegasus1.svg',
  'assets/svg/shaman.svg',
  'assets/svg/sparks.svg',
  'assets/svg/spiral.svg',
  'assets/svg/star_totem.svg',
  'assets/svg/stone.svg',
  'assets/svg/sun.svg',
  'assets/svg/tree_totem.svg',
  'assets/svg/wheel_totem.svg',
  'assets/svg/zerno.svg',
];

// ─────────────────────────────────────────────────────────────────────────────
// PARTICLE MODEL
// ─────────────────────────────────────────────────────────────────────────────

/// State of a single floating totem icon.
///
/// All physics quantities use logical pixels (x, y) and seconds (speeds,
/// frequencies). The coordinate origin is the top-left corner of the screen,
/// with y increasing downward — so moving upward decreases y.
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
  })  : x = baseX,      // x starts at baseX; sine shifts it each frame
        id = _nextId++; // unique identifier for Flutter's widget reconciler

  // ── Identity ──────────────────────────────────────────────────────────────

  /// Auto-incrementing id assigned at construction.
  /// Used as [ValueKey] in the widget tree so Flutter correctly reconciles
  /// particles when the list grows or shrinks mid-animation.
  static int _nextId = 0;
  final int id;

  // ── Immutable physics constants ───────────────────────────────────────────

  /// Path to the SVG asset for this particle.
  final String svgPath;

  /// The x-coordinate around which the particle oscillates horizontally.
  /// Equals the initial x position; sine drift is applied relative to this.
  final double baseX;

  /// Upward speed in logical pixels per second.
  /// Higher value → shorter time on screen.
  final double speedY;

  /// Amplitude of the horizontal sinusoidal drift, in logical pixels.
  /// Creates the "ember on a breeze" swaying motion.
  final double ampX;

  /// Angular frequency of the horizontal oscillation, in radians per second.
  /// Larger value → faster side-to-side wobble.
  final double freqX;

  /// Phase offset of the horizontal oscillation (radians).
  /// Randomised at spawn so each particle sways out of sync with its neighbours.
  final double phaseX;

  /// Icon render size in logical pixels. Randomised in the range 20–45 px.
  final double size;

  /// The opacity value used while the particle is in its "steady" flight zone
  /// (neither fading in nor fading out). Range: 0.10–0.15 per brand spec.
  final double steadyOpacity;

  /// Cached screen height used to compute the opacity envelope.
  /// Re-used every frame; avoids passing screenH into [update].
  final double screenH;

  // ── Mutable state (updated every tick) ───────────────────────────────────

  /// Current left edge of the icon, in logical pixels.
  double x;

  /// Current top edge of the icon, in logical pixels.
  double y;

  // ── Derived properties ────────────────────────────────────────────────────

  /// True when the icon has fully risen above the top of the screen.
  /// The particle is then recycled and a new one is spawned from below.
  bool get isDead => y + size < 0;

  /// Current opacity, driven by the particle's vertical position.
  ///
  /// Opacity envelope (based on normalised y ∈ [0, 1]):
  ///   • [0.88 … 1.0] — fade-in zone (particle enters from below)
  ///   • [0.28 … 0.88] — steady zone (brand-spec opacity: 0.10–0.15)
  ///   • [0.00 … 0.28] — fade-out zone (particle disappears near the top)
  double get opacity {
    // norm = 1.0 when the particle is at the bottom, 0.0 at the top.
    final norm = (y / screenH).clamp(0.0, 1.0);

    if (norm > 0.88) {
      // Fade in: 0 → steadyOpacity as the particle enters from below.
      return ((1.0 - norm) / 0.12) * steadyOpacity;
    }
    if (norm < 0.28) {
      // Fade out: steadyOpacity → 0 as the particle approaches the top third.
      return (norm / 0.28) * steadyOpacity;
    }

    // Steady flight.
    return steadyOpacity;
  }

  // ── Physics update ────────────────────────────────────────────────────────

  /// Advance the particle by [dt] seconds.
  ///
  /// [totalSec] is the accumulated physics time (clamped, not wall-clock time)
  /// used to compute the horizontal sine position.
  void update(double dt, double totalSec) {
    // Move upward.
    y -= speedY * dt;

    // Sinusoidal horizontal drift: mimics an ember drifting on a light breeze.
    x = baseX + ampX * sin(freqX * totalSec + phaseX);
  }

  // ── Factories ─────────────────────────────────────────────────────────────

  /// Creates a particle that enters the screen from below.
  ///
  /// Used for ongoing particle respawning after an old particle leaves the top.
  factory TotemParticle.spawn(double screenW, double screenH, Random rng) {
    final size = 20.0 + rng.nextDouble() * 25.0; // 20–45 px

    return TotemParticle(
      svgPath:       _kAssets[rng.nextInt(_kAssets.length)],
      // Keep the oscillation zone within [0, screenW] by clamping baseX.
      baseX:         size + rng.nextDouble() * (screenW - size * 2).clamp(0, screenW),
      // Spawn just below the visible area with a small random extra offset
      // to stagger the entry timing naturally.
      y:             screenH + rng.nextDouble() * screenH * 0.25,
      speedY:        16.0 + rng.nextDouble() * 16.0, // 16–32 px/s → ~10–20 s on screen
      ampX:          8.0  + rng.nextDouble() * 18.0, // 8–26 px lateral swing
      freqX:         0.18 + rng.nextDouble() * 0.32, // 0.18–0.50 rad/s
      phaseX:        rng.nextDouble() * 2 * pi,       // random start phase
      size:          size,
      steadyOpacity: 0.10 + rng.nextDouble() * 0.05, // 0.10–0.15 (brand spec)
      screenH:       screenH,
    );
  }

  /// Creates a particle at a random y position anywhere on screen.
  ///
  /// Used for the **initial seed** so the animation looks already in progress
  /// on first render, instead of being empty for several seconds while
  /// particles drift up from below.
  factory TotemParticle.seeded(double screenW, double screenH, Random rng) {
    final p = TotemParticle.spawn(screenW, screenH, rng);
    // Randomise y within the visible area.
    p.y = rng.nextDouble() * screenH;
    return p;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WIDGET
// ─────────────────────────────────────────────────────────────────────────────

/// Full-screen animated background layer of slowly rising, gently drifting
/// Piligrim totem icons.
///
/// Visual behaviour (Piligrim brand spec):
///   • Icons drift upward at 16–32 px/s with a sinusoidal lateral sway.
///   • Opacity: 0.10–0.15 (brand colour #F2EDE4); fade-in at the bottom,
///     fade-out before the top third of the screen.
///   • Icon sizes vary per-particle: 20–45 logical pixels.
///   • Up to [particleCount] icons are alive simultaneously (default: 20).
///
/// Performance design:
///   • A **single [Ticker]** drives all particles — one vsync callback per
///     frame regardless of particle count.
///   • Opacity is encoded directly into [ColorFilter.mode] (baked colour alpha)
///     to avoid the compositing-layer overhead of the [Opacity] widget.
///   • [SvgPicture.asset] caches the parsed SVG [Picture] per asset path;
///     changing `colorFilter` each frame only triggers a cheap repaint,
///     never a re-parse.
///   • [ValueKey] on each [Positioned] lets Flutter reconcile the particle
///     list in O(n) even when particles are removed mid-list.
///
/// Bug fix — "totems disappear after SplashScreen":
///   When an opaque route (e.g. SplashScreen) sits on top of this widget,
///   Flutter's [TickerMode] suppresses vsync callbacks while the [Ticker]'s
///   internal clock continues.  On route pop, the first resumed tick delivers
///   `elapsed − _lastElapsed` ≈ the entire splash duration (often 2–3 s).
///   Without mitigation, every particle moves `dt × speedY ≈ 3 × 32 = 96 px`
///   upward in one frame, all become `isDead`, and the screen goes blank.
///
///   **Fix:** `dt` is clamped to a maximum of two 30-fps frames (~66 ms),
///   and `_totalSec` is accumulated from the clamped dt (not raw elapsed),
///   so neither vertical nor horizontal position can jump on resume.
///
/// Usage:
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

  /// Number of totem particles kept alive simultaneously.
  /// 15–25 is the recommended range for a balanced density vs. performance.
  final int particleCount;

  @override
  State<FloatingTotemsBackground> createState() =>
      _FloatingTotemsBackgroundState();
}

class _FloatingTotemsBackgroundState extends State<FloatingTotemsBackground>
    with SingleTickerProviderStateMixin {

  // ── Animation driver ──────────────────────────────────────────────────────

  /// The vsync-aligned ticker that drives the particle simulation.
  /// Automatically paused by [TickerMode] when the widget is off-screen
  /// (e.g. hidden behind another route in the Navigator stack).
  late final Ticker _ticker;

  // ── Timing ────────────────────────────────────────────────────────────────

  /// The elapsed duration from the last [_onTick] call.
  /// Used to compute the raw inter-frame delta time.
  Duration _lastElapsed = Duration.zero;

  /// Accumulated physics time in seconds, advanced by the **clamped** dt.
  ///
  /// Deliberately decoupled from wall-clock time so that a large gap in
  /// vsync callbacks (ticker paused during navigation) does not cause the
  /// horizontal sine oscillation to jump position on resume.
  double _totalSec = 0.0;

  // ── Particles ─────────────────────────────────────────────────────────────

  final List<TotemParticle> _particles = [];
  final _rng = Random();

  // ── Layout ────────────────────────────────────────────────────────────────

  /// Cached widget size captured from [LayoutBuilder] during [build].
  /// The ticker reads this on the next vsync — safe because the field is
  /// always written before the ticker callback fires on the following frame.
  Size _size = Size.zero;

  /// True once the initial seed has been performed.
  /// The seed distributes particles randomly across the visible area so the
  /// animation appears in-progress from the very first frame.
  bool _seeded = false;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    // Start the ticker immediately; it will do nothing until _size is known.
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    // Disposing the ticker cancels the vsync registration and stops callbacks.
    _ticker.dispose();
    super.dispose();
  }

  // ── Tick handler ──────────────────────────────────────────────────────────

  void _onTick(Duration elapsed) {
    // ── Delta-time calculation ───────────────────────────────────────────
    final rawDt = (elapsed - _lastElapsed).inMicroseconds / 1e6;

    // Always update _lastElapsed with the true elapsed value so the *next*
    // frame's rawDt is relative to the correct baseline, even if we clamp.
    _lastElapsed = elapsed;

    // ── BUG FIX: clamp dt ────────────────────────────────────────────────
    // Cap dt to ≤ 66 ms (two 30-fps frames).
    //
    // Why this is needed:
    //   [SingleTickerProviderStateMixin] respects [TickerMode]. When an
    //   opaque route (SplashScreen) is pushed on top, TickerMode is
    //   disabled → the ticker stops firing, but its internal clock keeps
    //   running.  When the route is popped, TickerMode is re-enabled and
    //   the ticker resumes.  The first resumed callback has
    //     elapsed − _lastElapsed ≈ duration of the entire pause.
    //   Without this clamp, all particles jump several screen-heights in
    //   one frame, all become isDead simultaneously, and the screen goes
    //   completely blank — which is the reported bug.
    //
    // Effect:
    //   At 32 px/s × 0.066 s ≈ 2 px max jump per frame, so the animation
    //   seamlessly continues from where it paused.
    final dt = rawDt.clamp(0.0, 0.066);

    // Advance physics time using the **clamped** dt, not raw elapsed.
    // This keeps the horizontal sine position stable across pauses.
    _totalSec += dt;

    // ── Guard: skip physics until layout is known ────────────────────────
    if (_size == Size.zero) return;

    setState(() {
      // ── Initial seed (runs exactly once) ──────────────────────────────
      // Distribute particles across the whole visible area so the screen
      // looks populated immediately, rather than waiting 10–20 s while the
      // first wave drifts up from below.
      if (!_seeded) {
        _seeded = true;
        for (int i = 0; i < widget.particleCount; i++) {
          _particles.add(
            TotemParticle.seeded(_size.width, _size.height, _rng),
          );
        }
        // Skip the physics update on the seeding frame — particles are
        // placed at correct positions already.
        return;
      }

      // ── Physics update ────────────────────────────────────────────────
      for (final p in _particles) {
        p.update(dt, _totalSec);
      }

      // ── Recycle dead particles ────────────────────────────────────────
      // Remove particles that have fully exited the top of the screen.
      _particles.removeWhere((p) => p.isDead);

      // Spawn replacements from below to maintain the target density.
      while (_particles.length < widget.particleCount) {
        _particles.add(
          TotemParticle.spawn(_size.width, _size.height, _rng),
        );
      }
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Capture the current widget size so the ticker can use it.
        // This is a plain field assignment (not setState), which is safe
        // in build — it has no effect on the current frame's layout.
        _size = constraints.biggest;

        return Stack(
          // Clip particles that drift outside the widget bounds (e.g. after
          // horizontal sine swing near the edges).
          clipBehavior: Clip.hardEdge,
          children: [
            for (final p in _particles)
              _ParticleWidget(particle: p),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PARTICLE WIDGET
// ─────────────────────────────────────────────────────────────────────────────

/// Renders a single [TotemParticle] as a positioned, tinted SVG icon.
///
/// A dedicated widget class (rather than an inline builder) makes the Stack
/// children list easier to read and lets Flutter's reconciler use [ValueKey]
/// to match old and new elements efficiently.
class _ParticleWidget extends StatelessWidget {
  const _ParticleWidget({required this.particle});

  final TotemParticle particle;

  @override
  Widget build(BuildContext context) {
    // Convert 0.0–1.0 opacity to an 8-bit alpha value.
    final alpha = (particle.opacity * 255).round().clamp(0, 255);

    // Skip fully transparent particles to avoid unnecessary paint calls.
    if (alpha == 0) return const SizedBox.shrink();

    return Positioned(
      // ValueKey enables O(1) reconciliation when a particle is removed from
      // the middle of the list (which would otherwise misidentify survivors).
      key: ValueKey(particle.id),
      // particle.x is the icon's horizontal centre; offset by half-size to
      // convert to Positioned's left-edge coordinate.
      left: particle.x - particle.size / 2,
      top:  particle.y,
      child: SvgPicture.asset(
        particle.svgPath,
        width:  particle.size,
        height: particle.size,
        // Encode opacity directly into the ColorFilter instead of wrapping
        // in an Opacity widget.  Opacity creates a compositing layer
        // (saveLayer), adding GPU overhead for every particle every frame.
        // ColorFilter.mode is applied in the existing SVG paint pass with
        // zero additional layer cost.
        colorFilter: ColorFilter.mode(
          // Brand sky colour #F2EDE4 at the computed alpha.
          Color.fromARGB(alpha, 0xF2, 0xED, 0xE4),
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
