# Basic Usage
`GTweener([GFade()], child: FlutterLogo()),`

or

`FlutterLogo().gTween.fade()`

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
# Handoff Notes:
* Delay is not implemented
* I implemented scale/fade/move/custom effects for example
* I added some extensions to int, for 1.seconds, 500.milliseconds, etc
* One area I'm not sure on is extension method, `.gTween.copyWith()` vs `gTween(...)`
There's 3 approaches I see that we could take.
```dart
 // just use copyWith (current approach)
Logo().gTween.copyWith(duration: 1.seconds).fade();

// copy all constructor params (+ default values) for  GTweener, into the tween() extension method
Logo().gTween(duration: 1.seconds).fade();

// create dedicated `withX` methods on GTweener that are sugar over copyWith
Logo().gTween.withDuration(1.seconds).fade()
```

Example usage here:
https://github.com/gskinnerTeam/flutter-gtween/blob/master/example/lib/main.dart

Tween implementations here:
https://github.com/gskinnerTeam/flutter-gtween/blob/master/lib/src/tweens.dart
