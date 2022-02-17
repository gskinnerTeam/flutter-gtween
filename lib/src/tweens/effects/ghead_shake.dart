import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gtween/gtween.dart';

class GHeadShake extends GTween<double> {
  GHeadShake([this.magnitude = 1]) : super(from: 0, to: 1, curve: null);
  static final defaultDuration = .4.seconds;
  final double magnitude;

  /// Overrides the tween() and headShake() methods with
  /// defaults better suited to head-shake (longer duration, and no auto-play)
  @override
  GTweener tween(Widget child, {Key? key}) =>
      super.tween(child, key: key).copyWith(duration: defaultDuration, autoPlay: false);

  @override
  Widget build(Widget child, Animation<double> anim) {
    return withAnimatedBuilder(anim, (anim) {
      double x = sin((anim.value) * pi * 4);
      return Transform.translate(offset: Offset(x * 5 * magnitude, 0), child: child);
    });
  }
}

extension GHeadShakeExtension on GTweener {
  GTweener headShake([double magnitude = 1]) {
    return copyWith(
      tweens: List.of(tweens)..add(GHeadShake(magnitude)),
      duration: GHeadShake.defaultDuration,
      autoPlay: false,
    );
  }
}
