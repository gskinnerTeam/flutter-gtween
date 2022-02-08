import 'package:flutter/widgets.dart';

abstract class GTween<T> {
  GTween({this.curve, required this.from, required this.to});
  final Curve? curve;

  final T from;
  final T to;

  Widget build(BuildContext context, Widget child, Animation<double> anim);

  /// Wraps a CurvedAnimation if a curve is defined, returns original anim if not
  Animation<double> applyCurve(Animation<double> anim) =>
      curve == null ? anim : CurvedAnimation(parent: anim, curve: curve!);
}
