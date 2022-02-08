import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gtween/gtween.dart';

/// ///////////////////////////////////
/// Fade
class GFade extends GTween<double> {
  GFade({double from = 0, double to = 1, Curve? curve}) : super(from: from, to: to, curve: curve);

  @override
  Widget build(BuildContext context, Widget child, Animation<double> anim) {
    return FadeTransition(opacity: applyCurve(anim).drive(Tween(begin: from, end: to)), child: child);
  }
}

extension GFadeExtension on GTweener {
  GTweener fade({double from = 0, double to = 1, Curve? curve}) {
    return copyWith(tweens: List.of(tweens)..add(GFade(curve: curve, from: from, to: to)));
  }
}

/// ///////////////////////////////////
/// Scale
//TODO: Add scaleX and scaleY
class GScale extends GTween<double> {
  GScale({double from = 0, double to = 1, Curve? curve}) : super(from: from, to: to, curve: curve);

  @override
  Widget build(BuildContext context, Widget child, Animation<double> anim) {
    return ScaleTransition(scale: applyCurve(anim).drive(Tween(begin: from, end: to)), child: child);
  }
}

extension GScaleExtension on GTweener {
  GTweener scale({double from = 0, double to = 1, Curve? curve}) {
    return copyWith(tweens: List.of(tweens)..add(GScale(curve: curve, from: from, to: to)));
  }
}

/// ///////////////////////////////////
/// Move
class GMove extends GTween<Offset> {
  GMove({Offset from = Offset.zero, required Offset to, Curve? curve}) : super(from: from, to: to, curve: curve);

  @override
  Widget build(BuildContext context, Widget child, Animation<double> anim) => Transform.translate(
        offset: applyCurve(anim).drive(Tween(begin: from, end: to)).value,
        child: child,
      );
}

extension GMoveExtension on GTweener {
  GTweener move({Offset from = Offset.zero, required Offset to, Curve? curve}) {
    return copyWith(tweens: List.of(tweens)..add(GMove(curve: curve, from: from, to: to)));
  }
}

/// ///////////////////////////////////
/// Custom
//TODO: This could be generic? doesn't need to just support double... but is it worthwhile? They can easily lerp with a Tween themselves...
class GCustom extends GTween<double> {
  GCustom({
    double from = 0,
    double to = 1,
    Curve? curve,
    required this.builder,
  }) : super(from: from, to: to, curve: curve);

  Widget Function(BuildContext context, Widget child, Animation<double> anim) builder;

  @override
  Widget build(BuildContext context, Widget child, Animation<double> anim) => builder(context, child, anim);
}

extension GCustomExtension on GTweener {
  GTweener custom({
    double from = 0,
    double to = 1,
    Curve? curve,
    required Widget Function(BuildContext context, Widget child, Animation<double> anim) builder,
  }) {
    return copyWith(tweens: List.of(tweens)..add(GCustom(curve: curve, from: from, to: to, builder: builder)));
  }
}

/// ///////////////////////////////////
/// Head Shake
class GHeadShake extends GTween<double> {
  GHeadShake([this.magnitude = 1]) : super(from: 0, to: 1, curve: null);
  final double magnitude;

  // SB: Override [tween] method to set the default duration to something that works better for this effect
  @override
  GTweener tween(Widget child, {Key? key}) {
    return super.tween(child, key: key).copyWith(duration: .5.seconds);
  }

  @override
  Widget build(BuildContext context, Widget child, Animation<double> anim) {
    double x = sin(anim.value * pi * 4);
    return Transform.translate(offset: Offset(x * 15 * magnitude, 0), child: child);
  }
}

extension GHeadShakeExtension on GTweener {
  GTweener headShake() {
    return copyWith(tweens: List.of(tweens)..add(GHeadShake()));
  }
}
