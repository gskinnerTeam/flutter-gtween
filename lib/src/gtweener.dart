library gtween;

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

class GTweener<T> extends StatefulWidget {
  static Duration defaultDuration = const Duration(milliseconds: 300);

  const GTweener(
    this.tweens, {
    required this.child,
    this.duration,
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
  final bool autoPlay;
  final Curve curve;

  final void Function(GTweenController controller)? onInit;
  final void Function(GTweenController controller)? onUpdate;
  final void Function(GTweenController controller)? onComplete;

  GTweener copyWith({
    List<GTween>? tweens,
    Widget? child,
    Duration? duration,
    bool? autoPlay,
    Curve? curve,
    Key? key,
    void Function(GTweenController controller)? onInit,
    void Function(GTweenController controller)? onUpdate,
    void Function(GTweenController controller)? onComplete,
  }) =>
      GTweener(
        tweens ?? this.tweens,
        child: child ?? this.child,
        duration: duration ?? this.duration,
        autoPlay: autoPlay ?? this.autoPlay,
        curve: curve ?? this.curve,
        onInit: onInit ?? this.onInit,
        onUpdate: onUpdate ?? this.onUpdate,
        onComplete: onComplete ?? this.onComplete,
      );

  @override
  State<GTweener> createState() => GTweenerState();
}

// Public state so it can be accessed via GlobalKey
class GTweenerState extends State<GTweener> with SingleTickerProviderStateMixin {
  late final AnimationController anim = AnimationController(
    vsync: this,
    duration: widget.duration ?? GTweener.defaultDuration,
  )..addListener(_handleAnimationUpdate);

  // Controller is public so it can be accessed via GlobalKey
  late GTweenController controller = GTweenController(anim);

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay) anim.forward();
    widget.onInit?.call(controller);
  }

  @override
  void didUpdateWidget(covariant GTweener oldWidget) {
    if (oldWidget.duration != widget.duration) {
      anim.duration = widget.duration ?? GTweener.defaultDuration;
    }
    super.didUpdateWidget(oldWidget);
  }

  void _handleAnimationUpdate() {
    widget.onUpdate?.call(controller);
    if (anim.isCompleted) {
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
      final curve = tween.curve != null ? anim : CurvedAnimation(parent: anim, curve: widget.curve);
      child = tween.build(context, child, curve);
    }
    return child;
  }
}


extension GTweenerExtension on Widget {
  /// SB: This should probably have all the constructor args that GTweener has and be `gTween(...)` instead. 
  /// Downside is more for us to write/maintain. We'd have to duplicate default values and a bunch of params.
  ///  Added some discussion about this to the readme.
  GTweener get gTween => GTweener(const [], child: this);
}
