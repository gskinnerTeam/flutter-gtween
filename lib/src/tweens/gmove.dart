import 'package:flutter/material.dart';
import 'package:gtween/gtween.dart';

class GMove extends GTween<Offset> {
  const GMove({Offset from = Offset.zero, Offset to = Offset.zero, Curve? curve})
      : super(from: from, to: to, curve: curve);

  @override
  Widget build(Widget child, Animation<double> anim) =>
      Transform.translate(offset: tweenAndCurveAnim(anim).value, child: child);
}

extension GMoveExtension on GTweener {
  GTweener move({Offset from = Offset.zero, Offset to = Offset.zero, Curve? curve}) {
    return addTween(GMove(curve: curve, from: from, to: to));
  }
}
