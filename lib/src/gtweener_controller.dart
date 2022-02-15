import 'package:flutter/widgets.dart';

/// A simple controller for a tween. If not for the existence
/// of a delay param, this class would probably not need to exist as
/// it so closely mirrors animationController.
///
/// But given the need to restart with delay, we need a controller that
/// has knowledge of the tweener and its delay value.
/// Todo: Add 'useDelay' param to `restart` (and maybe `play`)
class GTweenerController {
  GTweenerController(this.animation);
  final AnimationController animation;

  /// Restarts animation from 0
  void restart() => animation.forward(from: animation.lowerBound);

  /// plays tween forward
  void forward({double? from}) => animation.forward(from: from);

  /// Plays tween in reverse
  void reverse({double? from}) => animation.reverse(from: from);

  /// Pauses the tween at it's current position, can be resumed with forward
  void stop() => animation.stop();

  /// Stops animation and positions it back at the start
  void reset() => animation
    ..stop()
    ..value = animation.lowerBound;
}
