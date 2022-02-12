import 'package:flutter/material.dart';
import 'package:gtween/gtween.dart';

class GBlur extends GTween<Offset> {
  const GBlur({Offset from = Offset.zero, Offset to = Offset.zero, Curve? curve})
      : super(from: from, to: to, curve: curve);

  @override
  Widget build(Widget child, Animation<double> anim) {
    final size = tweenAndCurveAnim(anim);
    return Blur(blurX: size.value.dx, blurY: size.value.dy, child: child);
  }
}

extension GBlurExtension on GTweener {
  GTweener blur({Offset from = Offset.zero, Offset to = Offset.zero, Curve? curve}) {
    return addTween(GBlur(curve: curve, from: from, to: to));
  }
}
