import 'package:flutter/material.dart';
import 'package:gtween/gtween.dart';

/// ///////////////////////////////////
/// Fade
class GFade extends GTween<double> {
  GFade({double from = 0, double to = 1, Curve? curve}) : super(from: from, to: to, curve: curve);

  @override
  Widget build(BuildContext context, Widget child, Animation<double> anim) {
    // TODO:  Apply from/to
    return FadeTransition(opacity: applyCurve(anim).drive(Tween(begin: from, end: to)), child: child);
  }
}

extension GFadeExtension on GTweener {
  GTweener fade({double from = 0, double to = 1, Curve? curve}) {
    return copyWith(tweens: List.from(tweens)..add(GFade(curve: curve, from: from, to: to)));
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
    return copyWith(tweens: List.from(tweens)..add(GScale(curve: curve, from: from, to: to)));
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
    return copyWith(tweens: List.from(tweens)..add(GMove(curve: curve, from: from, to: to)));
  }
}

/// ///////////////////////////////////
/// Custom
//TODO: This could be generic? doesn't need to just support double... but is it worthwhile? They can easily lerp with a Tween themselves...
class GTweenBuilder extends GTween<double> {
  GTweenBuilder({
    double from = 0,
    double to = 1,
    Curve? curve,
    required this.builder,
  }) : super(from: from, to: to, curve: curve);

  Widget Function(BuildContext context, Widget child, Animation<double> anim) builder;

  @override
  Widget build(BuildContext context, Widget child, Animation<double> anim) => builder(context, child, anim);
}

extension GTweenBuilderExtension on GTweener {
  GTweener tweenBuilder({
    double from = 0,
    double to = 1,
    Curve? curve,
    required Widget Function(BuildContext context, Widget child, Animation<double> anim) builder,
  }) {
    return copyWith(tweens: List.from(tweens)..add(GTweenBuilder(curve: curve, from: from, to: to, builder: builder)));
  }
}
