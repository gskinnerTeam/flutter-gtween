library gtween;

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:gtween/src/gtween.dart';
import 'package:gtween/src/gtweener_controller.dart';

typedef TweenCallback = void Function(GTweenerController controller);

/// A stateful widget that manages an AnimationController driving N tweens.
/// Exposes a [GTweenerController] that ancestor widgets can use to control
/// the internal animation controller.
/// Notifies listeners of status via onInit, onUpdate and onComplete delegates.
class GTweener<T> extends StatefulWidget {
  static Duration defaultDuration = const Duration(milliseconds: 300);

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

// Public state so it can be accessed via GlobalKey
class GTweenerState extends State<GTweener> with SingleTickerProviderStateMixin {
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: widget.duration ?? GTweener.defaultDuration,
  )..addListener(_handleAnimationUpdate);

  // Controller is public so it can be accessed via GlobalKey
  late GTweenerController controller = GTweenerController(_anim);

  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay) {
      if (widget.delay != null && widget.delay != Duration.zero) {
        _createDelayTimer();
      } else {
        _anim.forward();
      }
    }
    widget.onInit?.call(controller);
  }

  @override
  void dispose() {
    _anim.dispose();
    _delayTimer?.cancel();
    super.dispose();
  }

  /// TODO: Add tests around changing the delay or duration externally.
  /// Add tests for onComplete and onInit
  /// Add tests for auto-play / manual play
  /// Add some sort of dispose test?
  @override
  void didUpdateWidget(covariant GTweener oldWidget) {
    if (oldWidget.duration != widget.duration) {
      _anim.duration = widget.duration ?? GTweener.defaultDuration;
    }
    if (oldWidget.delay != widget.delay) {
      _delayTimer?.cancel();
      _createDelayTimer();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _createDelayTimer() {
    _delayTimer?.cancel();
    if (widget.delay == null) return;
    _delayTimer = Timer.periodic(widget.delay!, _handleDelayTimerComplete);
  }

  void _handleDelayTimerComplete(Timer timer) {
    if (_anim.isAnimating == false) controller.forward();
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
      // If the tween has its own curve, feed it a linear animation. Otherwise, use the base curve.
      final curve = tween.curve != null ? _anim : CurvedAnimation(parent: _anim, curve: widget.curve);
      child = tween.build(child, curve);
    }
    return child;
  }
}
