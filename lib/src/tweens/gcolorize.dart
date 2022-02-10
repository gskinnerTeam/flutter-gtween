import 'package:flutter/material.dart';
import 'package:gtween/gtween.dart';

class GColorize extends GTween<Color?> {
  GColorize({Color? from, Color? to, Curve? curve, this.blendMode = BlendMode.srcIn})
      : super(from: from, to: to, curve: curve);

  final BlendMode blendMode;
  @override
  Widget build(Widget child, Animation<double> anim) {
    Color? color = curveAnim(anim).drive(ColorTween(begin: from, end: to)).value;
    final filter = ColorFilter.mode(color ?? Colors.transparent, blendMode);
    return ColorFiltered(colorFilter: filter, child: child);
  }
}

extension GColorizeExtension on GTweener {
  GTweener colorize({Color? from, Color? to, Curve? curve, BlendMode? blendMode}) {
    return addTween(GColorize(from: from, to: to, curve: curve));
  }
}
