import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gtween/gtween.dart';

void main() {
  testWidgets('int and double extensions', (tester) async {
    expect(5.microseconds, const Duration(microseconds: 5));
    expect(5.milliseconds, const Duration(milliseconds: 5));
    expect(5.seconds, const Duration(seconds: 5));
    expect(5.minutes, const Duration(minutes: 5));
    expect(5.hours, const Duration(hours: 5));
    expect(5.days, const Duration(days: 5));
    expect(1.5.seconds, const Duration(milliseconds: 1500));
  });

  testWidgets('GTweener.withX methods (copyWith)', (tester) async {
    var tweener = const GTweener([], child: FlutterLogo());
    void handleInit(GTweenerController _) {}
    void handleUpdate(GTweenerController _) {}
    void handleComplete(GTweenerController _) {}
    expect(tweener.withAutoPlay(false).autoPlay, false);
    expect(tweener.withAutoPlay(true).autoPlay, true);
    final tweens = [const GFade()];
    expect(tweener.withTweens(tweens).tweens, tweens);
    expect(tweener.addTween(const GFade()).tweens.length, 1);
    expect(tweener.withDuration(2.seconds).duration, 2.seconds);
    expect(tweener.withCurve(Curves.bounceInOut).curve, Curves.bounceInOut);
    expect(tweener.withDelay(3.seconds).delay, 3.seconds);
    expect(tweener.withInit(handleInit).onInit, handleInit);
    expect(tweener.withUpdate(handleUpdate).onUpdate, handleUpdate);
    expect(tweener.withComplete(handleComplete).onComplete, handleComplete);
    expect(tweener.withKey(const ValueKey(0)).key, const ValueKey(0));
  });
}
