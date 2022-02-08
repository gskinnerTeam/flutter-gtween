import 'package:flutter/widgets.dart';
import 'package:gtween/gtween.dart';

abstract class GTween<T> {
  GTween({this.curve, required this.from, required this.to});
  final Curve? curve;

  final T from;
  final T to;

  Widget build(BuildContext context, Widget child, Animation<double> anim);

  /// Allows any tween to be used to initiate a tween:
  ///   GFade().tween(Logo());
  GTweener tween(Widget child, {Key? key}) => GTweener([this], child: child, key: key);

  /// Wraps a CurvedAnimation if a curve is defined, returns original anim if not
  Animation<double> applyCurve(Animation<double> anim) =>
      curve == null ? anim : CurvedAnimation(parent: anim, curve: curve!);
}
