import 'package:flutter/material.dart';
import 'package:gtween/gtween.dart';

/// Add `gTween` to all widgets
extension GTweenerExtension on Widget {
  GTweener get gTweener => GTweener(const [], child: this);
}

/// Add staggered animation to a lists of widgets
extension ListExtensions on List<Widget> {
  /// Wraps each list child in a tweener and sets the various params / callbacks.
  /// Calculates the delay for each child using:
  ///   delay + interval * childIndex
  /// Will skip any delay for children beyond maxIndex, but will still apply the tween.
  List<Widget> gTweenSequence(
    List<GTween> tweens, {
    Duration? interval,
    Curve curve = Curves.linear,
    Duration delay = Duration.zero,
    int? maxIndex,
    void Function(GTweenerController anim)? onInit,
    void Function(GTweenerController anim)? onUpdate,
    void Function(GTweenerController anim)? onComplete,
  }) {
    return map(
      (w) {
        bool doDelay = maxIndex == null || indexOf(w) < maxIndex;
        final i = interval ?? GTweener.defaultSequenceInterval;
        final del = doDelay ? delay + i * indexOf(w) : Duration.zero;
        return GTweener(tweens,
            delay: del, curve: curve, child: w, onInit: onInit, onUpdate: onUpdate, onComplete: onComplete);
      },
    ).toList();
  }
}

/// Add shortcuts to int and double to to make it easier to work with duration
extension DurationExtensions on int {
  Duration get microseconds => Duration(microseconds: this);
  Duration get milliseconds => Duration(milliseconds: this);
  Duration get seconds => Duration(seconds: this);
  Duration get minutes => Duration(minutes: this);
  Duration get hours => Duration(hours: this);
  Duration get days => Duration(days: this);
}

extension DoubleDurationExtensions on double {
  Duration get seconds => Duration(milliseconds: (this * 1000).round());
}

/// Extensions method to provide `copyWith` and `withX` methods on GTweener.
/// Placing them here so as to not pollute the main class with boilerplate/noise.
extension GTweenerCopyWithExtensions on GTweener {
  // Creates a copy of this tweener but with the given fields replaced with the new values.
  GTweener copyWith({
    List<GTween>? tweens,
    Widget? child,
    Duration? duration,
    Duration? delay,
    bool? autoPlay,
    Curve? curve,
    Key? key,
    TweenCallback? onInit,
    TweenCallback? onUpdate,
    TweenCallback? onComplete,
  }) =>
      GTweener(
        tweens ?? this.tweens,
        child: child ?? this.child,
        duration: duration ?? this.duration,
        delay: delay ?? this.delay,
        autoPlay: autoPlay ?? this.autoPlay,
        curve: curve ?? this.curve,
        onInit: onInit ?? this.onInit,
        onUpdate: onUpdate ?? this.onUpdate,
        onComplete: onComplete ?? this.onComplete,
        key: key ?? this.key,
      );

  /// Creates a copy of this tweener with one additional tween
  GTweener addTween(GTween value) => withTweens(List.of(tweens)..add(value));

  /// Creates a copy of this tweener with a different set of tweens
  GTweener withTweens(List<GTween> value) => copyWith(tweens: value);

  /// Creates a copy of this tweener with a different duration
  GTweener withDuration(Duration value) => copyWith(duration: value);

  /// Creates a copy of this tweener with a different delay
  GTweener withDelay(Duration value) => copyWith(delay: value);

  /// Creates a copy of this tweener with a different autoPlay
  GTweener withAutoPlay(bool value) => copyWith(autoPlay: value);

  /// Creates a copy of this tweener with a different curve
  GTweener withCurve(Curve value) => copyWith(curve: value);

  /// Creates a copy of this tweener with a different onInit
  GTweener withInit(TweenCallback value) => copyWith(onInit: value);

  /// Creates a copy of this tweener with a different onUpdate
  GTweener withUpdate(TweenCallback value) => copyWith(onUpdate: value);

  /// Creates a copy of this tweener with a different onComplete
  GTweener withComplete(TweenCallback value) => copyWith(onComplete: value);

  /// Creates a copy of this tweener with a different key
  GTweener withKey(Key key) => copyWith(key: key);
}
