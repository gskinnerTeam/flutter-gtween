# Handoff Notes:
* Delay is not implemented
* I implemented a scale/fade/move/custom effects for example
* One area I'm not sure on is `.tween.copyWith()` vs `tween(...)`
There's 3 approaches I see that we could take.
```
 // just use copyWith (current approach)
Logo().tween.copyWith(duration: Times.fast).fade();

// copy all constructor params (+ default values) for  GTweener, into the tween() extension method
Logo().tween(duration: Times.fast).fade();

// create dedicated `withX` methods on GTweener that are sugar over copyWith
Logo().tween.withDuration(Times.fast).fade()
```

Example usage here:
https://github.com/gskinnerTeam/flutter-gtween/blob/master/example/lib/main.dart

Tween implementations here:
https://github.com/gskinnerTeam/flutter-gtween/blob/master/lib/src/tweens.dart