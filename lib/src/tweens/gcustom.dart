import 'package:flutter/material.dart';
import 'package:gtween/gtween.dart';

typedef CustomTweenBuilder = Widget Function(Widget child, Animation<double> anim);

//TODO: Maybe make this generic GCustom<T>, don't want to hurt the common case of tweening a double though.
class GCustom extends GTween<double> {
  GCustom({
    double from = 0,
    double to = 1,
    Curve? curve,
    required this.builder,
  }) : super(from: from, to: to, curve: curve);

  CustomTweenBuilder builder;

  @override
  Widget build(Widget child, Animation<double> anim) => builder(
        child,
        tweenAndCurveAnim(anim), // pass a curved Animation<double> into the builder
      );
}

extension GCustomExtension on GTweener {
  GTweener custom({
    double from = 0,
    double to = 1,
    Curve? curve,
    required CustomTweenBuilder builder,
  }) {
    return addTween(GCustom(curve: curve, from: from, to: to, builder: builder));
  }
}
