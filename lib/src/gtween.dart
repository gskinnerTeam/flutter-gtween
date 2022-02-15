import 'package:flutter/widgets.dart';
import 'package:gtween/gtween.dart';

/// Base class for all GTweens. Defines the common from/to/curve fields that all tweens require.
///
/// Provides utility methods for the concrete tweens to use.
///
/// Declares a generic `tween()` method which allows any tween to wrap itself around a widget.
/// This provides an opportunity for sub-classes to implement opinionated GTweener defaults (see [GHeadShake] for an example of this)
abstract class GTween<T> {
  const GTween({required this.from, required this.to, this.curve});
  final T from;
  final T to;
  final Curve? curve;

  Widget build(Widget child, Animation<double> anim);

  /// Enables alternate syntax.
  ///   GFade().tween(Logo());
  /// TODO: Consider whether we want this. On one hand, it's a convenient alternate syntax. On the other, it becomes the 3rd way to make a tween, is that 1 to many?
  GTweener tween(Widget child, {Key? key}) => GTweener([this], child: child, key: key);

  /// Wraps a CurvedAnimation if a curve is defined, returns original anim if not.
  /// Also applies a Tween to map the anim.value : from/to
  Animation<double> curveAnim(Animation<double> anim) =>
      curve == null ? anim : CurvedAnimation(parent: anim, curve: curve!);

  /// Applies both the current curve as well as the tween mapping
  Animation<T> tweenAndCurveAnim(Animation<double> anim, {bool tween = true}) =>
      curveAnim(anim).drive(Tween(begin: from, end: to));
}
