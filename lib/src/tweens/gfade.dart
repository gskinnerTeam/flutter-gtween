import 'package:flutter/material.dart';
import 'package:gtween/gtween.dart';

class GFade extends GTween<double> {
  GFade({double from = 0, double to = 1, Curve? curve}) : super(from: from, to: to, curve: curve);

  FadeTransition? _fade;
  @override
  Widget build(Widget child, Animation<double> anim) {
    _fade ??= FadeTransition(opacity: tweenAndCurveAnim(anim), child: child);
    return _fade!;
  }
}

extension GFadeExtension on GTweener {
  GTweener fade({double from = 0, double to = 1, Curve? curve}) {
    return addTween(GFade(curve: curve, from: from, to: to));
  }
}
