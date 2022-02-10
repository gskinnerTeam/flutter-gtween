import 'package:flutter/material.dart';
import 'package:gtween/gtween.dart';

class GScale extends GTween<double> {
  const GScale({double from = 0, double to = 1, Curve? curve}) : super(from: from, to: to, curve: curve);
  @override
  Widget build(Widget child, Animation<double> anim) =>
      Transform.scale(scale: tweenAndCurveAnim(anim).value, child: child);
}

/// ScaleX
class GScaleX extends GTween<double> {
  const GScaleX({double from = 0, double to = 1, Curve? curve}) : super(from: from, to: to, curve: curve);
  @override
  Widget build(Widget child, Animation<double> anim) =>
      Transform.scale(scaleX: tweenAndCurveAnim(anim).value, child: child);
}

/// ScaleY
class GScaleY extends GTween<double> {
  const GScaleY({double from = 0, double to = 1, Curve? curve}) : super(from: from, to: to, curve: curve);
  @override
  Widget build(Widget child, Animation<double> anim) =>
      Transform.scale(scaleY: tweenAndCurveAnim(anim).value, child: child);
}

/// Extensions
extension GScaleExtension on GTweener {
  GTweener scale({double from = 0, double to = 1, Curve? curve}) {
    return addTween(GScale(curve: curve, from: from, to: to));
  }

  GTweener scaleX({double from = 0, double to = 1, Curve? curve}) {
    return addTween(GScaleX(curve: curve, from: from, to: to));
  }

  GTweener scaleY({double from = 0, double to = 1, Curve? curve}) {
    return addTween(GScaleY(curve: curve, from: from, to: to));
  }
}
