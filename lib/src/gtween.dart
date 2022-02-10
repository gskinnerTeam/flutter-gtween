import 'package:flutter/widgets.dart';
import 'package:gtween/gtween.dart';

/// Base class for all GTweens. Defines the common from/to/curve fields that all tweens require.
///
/// Provides utility methods `curveAnim` and `tweenAndCurveAnim` for the concrete tweens to use.
///
/// Also declares a generic `tween()` method which allows any tween to wrap itself around a widget
/// and also be overridden to generate an opinionated GTweener instance (see [GHeadShake] for an example of this)
abstract class GTween<T> {
  const GTween({required this.from, required this.to, this.curve});
  final T from;
  final T to;
  final Curve? curve;

  Widget build(Widget child, Animation<double> anim);

  /// Allows shortcut syntax:
  ///   GFade().tween(Logo());
  GTweener tween(Widget child, {Key? key}) => GTweener([this], child: child, key: key);

  /// Wraps a CurvedAnimation if a curve is defined, returns original anim if not.
  /// Also applies a Tween to map the anim.value : from/to
  Animation<double> curveAnim(Animation<double> anim) =>
      curve == null ? anim : CurvedAnimation(parent: anim, curve: curve!);

  Animation<T> tweenAndCurveAnim(Animation<double> anim, {bool tween = true}) =>
      curveAnim(anim).drive(Tween(begin: from, end: to));
}
