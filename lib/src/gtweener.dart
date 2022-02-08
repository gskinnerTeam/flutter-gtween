library gtween;

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:gtween/src/abstract_gtween.dart';

// SB: Just an idea on how we could have a controller, could also just put these methods on the state itself.
class GTweenController {
  GTweenController(this.animation);
  final AnimationController animation;

  void restart() => animation.forward(from: 0);
  void play() => animation.forward();
  void pause() => animation.stop();
  void reset() => animation
    ..stop()
    ..value = animation.lowerBound;
}

typedef TweenCallback = void Function(GTweenController controller);

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
  final List<GTween> tweens;
  final Widget child;
  final Duration? duration;
  final Duration? delay;
  final bool autoPlay;
  final Curve curve;

  final TweenCallback? onInit;
  final TweenCallback? onUpdate;
  final TweenCallback? onComplete;

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
      );

  GTweener withDuration(Duration value) => copyWith(duration: value);
  GTweener withDelay(Duration value) => copyWith(delay: value);
  GTweener withAutoPlay(bool value) => copyWith(autoPlay: value);
  GTweener withCurve(Curve value) => copyWith(curve: value);
  GTweener withInit(TweenCallback value) => copyWith(onInit: value);
  GTweener withUpdate(TweenCallback value) => copyWith(onUpdate: value);
  GTweener withComplete(TweenCallback value) => copyWith(onComplete: value);

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
  late GTweenController controller = GTweenController(_anim);

  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay) {
      if (widget.delay != null) {
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

  void _handleAnimationUpdate() {
    widget.onUpdate?.call(controller);
    if (_anim.isCompleted) {
      widget.onComplete?.call(controller);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Skip wrapping the tweener at all if our tweens are empty.
    if (widget.tweens.isEmpty) return widget.child;

    Widget child = widget.child;
    // Apply all tweens
    for (var tween in widget.tweens) {
      // If the tween has its own curve, feed it a linear animation. Otherwise, use the base curve.
      final curve = tween.curve != null ? _anim : CurvedAnimation(parent: _anim, curve: widget.curve);
      child = tween.build(context, child, curve);
    }
    return child;
  }

  void _handleDelayTimerComplete(Timer timer) {
    if (_anim.isAnimating == false) controller.play();
  }
}

extension GTweenerExtension on Widget {
  /// SB: This should probably have all the constructor args that GTweener has and be `gTween(...)` instead.
  /// Downside is more for us to write/maintain. We'd have to duplicate default values and a bunch of params.
  ///  Added some discussion about this to the readme.
  GTweener get gTween => GTweener(const [], child: this);
}
