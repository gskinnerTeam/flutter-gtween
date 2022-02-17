import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gtween/gtween.dart';

class GBlur extends GTween<Offset> {
  GBlur({Offset from = Offset.zero, Offset to = Offset.zero, Curve? curve}) : super(from: from, to: to, curve: curve);

  @override
  Widget build(Widget child, Animation<double> anim) {
    return withAnimatedBuilder(anim, (anim) {
      final size = tweenAndCurveAnim(anim);
      return ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: size.value.dx,
          sigmaY: size.value.dy,
          tileMode: TileMode.decal,
        ),
        child: child,
      );
    });
  }
}

extension GBlurExtension on GTweener {
  GTweener blur({Offset from = Offset.zero, Offset to = Offset.zero, Curve? curve}) {
    return addTween(GBlur(curve: curve, from: from, to: to));
  }
}
