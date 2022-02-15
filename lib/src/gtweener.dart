library gtween;

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:gtween/gtween.dart';

typedef TweenCallback = void Function(GTweenerController controller);

/// A stateful widget that manages an AnimationController driving N tweens.
/// Exposes a [GTweenerController] that ancestor widgets can use to control
/// the internal animation controller.
///
/// Notifies listeners of status via onInit, onUpdate and onComplete delegates.
class GTweener<T> extends StatefulWidget {
  static Duration defaultDuration = const Duration(milliseconds: 300);
  static Duration defaultSequenceInterval = const Duration(milliseconds: 100);

  const GTweener(
    this.tweens, {
    required this.child,
    this.duration,
    this.delay,
    this.autoPlay = true,
    this.curve = Curves.linear,
    this.onInit,
    this.onUpdate,
    this.onComplete,
    Key? key,
  }) : super(key: key);

  /// A list of of GTween objects
  final List<GTween> tweens;

  /// The child to be tweened
  final Widget child;

  /// The duration of the tween
  final Duration? duration;

  /// Initial delay for the tween when using autoplay
  final Duration? delay;

  /// Determines whether tween starts playing automatically or waits to be started
  final bool autoPlay;

  /// The easing curve, defaults to linear.
  final Curve curve;

  /// Called once, when the tweener is first initialized.
  final TweenCallback? onInit;

  /// Called each time the animation is updated
  final TweenCallback? onUpdate;

  /// Called each time the animation completes
  final TweenCallback? onComplete;

  @override
  State<GTweener> createState() => GTweenerState();
}

/// Public state so it can be accessed via GlobalKey
class GTweenerState extends State<GTweener> with SingleTickerProviderStateMixin {
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: widget.duration ?? GTweener.defaultDuration,
  );

  Timer? _delayTimer;

  // Controller is public so it can be accessed externally
  late final GTweenerController controller = GTweenerController(_anim);

  @override
  void initState() {
    super.initState();
    _anim.addListener(_handleAnimationUpdate);
    if (widget.autoPlay) _scheduleAutoPlay();
    widget.onInit?.call(controller);
  }

  @override
  void dispose() {
    _anim.dispose();
    _delayTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant GTweener oldWidget) {
    if (oldWidget.duration != widget.duration) {
      _anim.duration = widget.duration ?? GTweener.defaultDuration;
    }
    super.didUpdateWidget(oldWidget);
  }

  void _scheduleAutoPlay() {
    _delayTimer?.cancel();
    if (widget.delay == null || widget.delay == Duration.zero) {
      _anim.forward();
    } else {
      _delayTimer = Timer.periodic(widget.delay!, (_) {
        _anim.forward();
        _delayTimer?.cancel();
      });
    }
  }

  void _handleAnimationUpdate() {
    widget.onUpdate?.call(controller);
    if (_anim.isCompleted) {
      widget.onComplete?.call(controller);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;
    for (var tween in widget.tweens) {
      Animation<double> tweenAnim = _anim;
      // If the tween has no curve of its own, apply the parent curve
      if (tween.curve == null) {
        tweenAnim = CurvedAnimation(parent: _anim, curve: widget.curve);
      }
      // Build the tween at current position with the desired curve
      child = tween.build(child, tweenAnim);
    }
    return child;
  }
}
