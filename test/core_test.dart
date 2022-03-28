import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gtween/gtween.dart';

BuildContext? context;

void main() {
  testWidgets('core curves and animation controller tests', (tester) async {
    // Start a tween with linear curve
    var tweener = const FlutterLogo().gTweener.fade().scale();
    await tester.pumpWidget(TestApp(tweener.withDuration(1.seconds)));
    // Play app for 0.5s and check that opacity is .5
    await tester.pump(.5.seconds);
    expect(
      tester.widget(find.byType(FadeTransition).last),
      isA<FadeTransition>().having((ft) => ft.opacity.value, 'opacity', .5),
    );
    Transform expectedScale =
        (GScale().build(const Placeholder(), const AlwaysStoppedAnimation<double>(.5)) as AnimatedChild).buildChild()
            as Transform;
    expect(
      tester.widget(find.byType(AnimatedChild).last),
      isA<AnimatedChild>().having((c) => (c.buildChild() as Transform).transform, 'scale', expectedScale.transform),
    );
    // Let animation finish, and check that opacity is 1
    await tester.pumpAndSettle();
    expect(
      tester.widget(find.byType(FadeTransition).last),
      isA<FadeTransition>().having((ft) => ft.opacity.value, 'opacity', 1),
    );

    // Start a tweener with easeOut curve
    tweener = const FlutterLogo().gTweener.fade();
    tweener = tweener.copyWith(duration: 1.seconds, curve: Curves.easeOut);
    await tester.pumpWidget(TestApp(tweener));
    // Play app for .5s and check that opacity is easeOut(.5)
    await tester.pump(.5.seconds);
    expect(
      tester.widget(find.byType(FadeTransition).last),
      isA<FadeTransition>().having((ft) => ft.opacity.value, 'opacity', Curves.easeOut.transform(.5)),
    );

    // Test a tween curve override,
    // The tweeners curve (easeIn) should be ignored for easeOut
    tweener = const FlutterLogo().gTweener.fade(curve: Curves.easeOut);
    tweener = tweener.withCurve(Curves.easeIn).withDuration(1.seconds);
    var expectedOpacity = Curves.easeOut.transform(.5);
    await tester.pumpWidget(TestApp(tweener));
    await tester.pump(.5.seconds);
    expect(
      tester.widget(find.byType(FadeTransition).last),
      isA<FadeTransition>().having((ft) => ft.opacity.value, 'opacity', expectedOpacity),
    );
  });
}

/// Small test harness for a GTweener instance.
class TestApp extends StatelessWidget {
  const TestApp(this.child, {Key? key}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext c) {
    // Stash a build context so we can call state.build on the tweener for testing
    context = c;
    // Use ObjectKey to get a fresh app each time child changes
    return MaterialApp(key: ObjectKey(child), home: child);
  }
}
