import 'package:flutter/material.dart';
import 'package:gtween/gtween.dart';

class GRotate extends GTween<double> {
  GRotate({double from = 0, double to = 0, Curve? curve}) : super(from: from, to: to, curve: curve);
  static const degreesToRad = 0.0174533;
  @override
  Widget build(Widget child, Animation<double> anim) => withAnimatedBuilder(anim, (anim) {
        return Transform.rotate(
          angle: tweenAndCurveAnim(anim).value * degreesToRad,
          child: child,
        );
      });
}

/// Extensions
extension GRotateExtension on GTweener {
  GTweener rotate({double from = 0, double to = 1, Curve? curve}) {
    return addTween(GRotate(curve: curve, from: from, to: to));
  }
}
