import 'package:flutter/widgets.dart';

class GTweenerController {
  GTweenerController(this.animation);
  final AnimationController animation;

  /// Todo: Restart should take a 'useDelay' param (maybe play() as well?)
  /// Restarts animation from 0
  void restart() => animation.forward(from: 0);

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
