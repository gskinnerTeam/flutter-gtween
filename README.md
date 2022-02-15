# Basic Usage
`GTweener([GFade()], child: FlutterLogo()),`

or

`FlutterLogo().gTween.fade().withDelay(1.seconds)`

# Advanced Usage
```dart
GTweener(
  [GFade(), GScale(curve: Curves.easeOutBack, from: .8)],
  duration: 1.seconds,
  curve: Curves.easeInCubic,
  onInit: (c) => _fadeTween1 = c..play(),
  onUpdate: (_) => print('Update: ${_fadeTween1?.animation.value}'),
  onComplete: (_) => print('Complete'),
  autoPlay: false,
  child: FlutterLogo(),
),
```

or

```dart
 FlutterLogo().gTween.fade().scale(curve: Curves.easeOutBack, from: .8).copyWith(
  duration: 1.seconds,
  curve: Curves.easeInCubic,
  onInit: (c) => _fadeTween2 = c..play(),
  onUpdate: (_) => print('Update: ${_fadeTween2?.animation.value}'),
  onComplete: (_) => print('Complete'),
  autoPlay: false,
),
```

# Custom Tween
```dart
// fade + scale + left > right alignment
FlutterLogo().gTween.custom(builder: (_, child, anim) {
  final alignAnim = anim.drive(Tween(begin: Alignment.centerRight, end: Alignment.centerLeft));
  return FadeTransition(
      opacity: anim,
      child: ScaleTransition(
        scale: anim,
        child: AlignTransition(alignment: alignAnim, child: child),
      ));
});
```           
# Notes:
* Implemented effects so far:
  * Scale
  * Move
  * Fade
  * GCustom
  * GHeadShake
  * Rotate,
  * ScaleX/ScaleY
  * Color
  * Blur
  
* Todo:
  * Other animate.css style effects (https://animate.style/)
    * bounce, flash, pulse, rubberband, shakeX, shakeY, swing, tada, jello, heartbeat
    * Motion effects (zoomInDown, slideInLeft, bounceOut, rotateInDownLeft. lightSpeedInRight, flipInX, fadeOutBottomRight  etc)
  * Add a 'useDelay' param for restart/play
  * (maybe) Add mirror/repeat/yoyo functionality for play/restart
  * Add tests around changing the delay or duration externally.
  * Add tests for onComplete and onInit
  * Add tests for auto-play / manual play
  * Add some sort of dispose test?

Example usage here:
https://github.com/gskinnerTeam/flutter-gtween/blob/master/example/lib/main.dart

Tween implementations here:
https://github.com/gskinnerTeam/flutter-gtween/blob/master/lib/src/tweens.dart
