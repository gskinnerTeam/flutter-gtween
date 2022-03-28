import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gtween/gtween.dart';

void main() {
  /// Runs tests on each tweens build() method,
  /// Inspects the returned widgets to ensure they are returning what is expected
  /// Assigns various eases to test that curves are being applied properly.
  testWidgets('individual tweens', (tester) async {
    /// calls `.build()` on a tween at 50% progress and returns the widget
    Widget buildTween(GTween value) {
      const position = .5;
      return value.build(const Placeholder(), const AlwaysStoppedAnimation<double>(position));
    }

    /// Fade
    final fade = buildTween(GFade(curve: Curves.easeOut)) as FadeTransition;
    expect(fade.opacity.value, Curves.easeOut.transform(.5));

    /// Scale
    /// TODO: Fix these tests, they are broken because a AnimatedBuilder wraps some of the tweens
    final scale = (buildTween(GScale(curve: Curves.elasticIn)) as AnimatedChild).child as Transform;
    expect(scale.transform.entry(0, 0), Curves.elasticIn.transform(.5));
    expect(scale.transform.entry(1, 1), Curves.elasticIn.transform(.5));
    // ScaleX
    final scaleX = (buildTween(GScaleX(curve: Curves.easeOut)) as AnimatedChild).child as Transform;
    expect(scaleX.transform.entry(0, 0), Curves.easeOut.transform(.5));
    // ScaleY
    final scaleY = (buildTween(GScaleY(curve: Curves.easeInCubic)) as AnimatedChild).child as Transform;
    expect(scaleY.transform.entry(1, 1), Curves.easeInCubic.transform(.5));

    /// Move
    final move = (buildTween(GMove(from: Offset(-100, 0))) as AnimatedChild).child as Transform;
    final moveComparison = Transform.translate(offset: const Offset(-50, 0));
    expect(move.transform, moveComparison.transform);

    /// Rotate
    final rotation = (buildTween(GRotate(from: -90)) as AnimatedChild).child as Transform;
    var rotatedMinus45 = Transform.rotate(angle: -45 * GRotate.degreesToRad);
    expect(rotatedMinus45.transform, rotation.transform);

    /// Color
    final colorTween = ColorTween(begin: Colors.red, end: Colors.blue);
    final color =
        (buildTween(GColorize(from: colorTween.begin, to: colorTween.end)) as AnimatedChild).child as ColorFiltered;
    final colorComparison = const AlwaysStoppedAnimation<double>(.5).drive(colorTween);
    expect(color.colorFilter, ColorFilter.mode(colorComparison.value!, BlendMode.srcIn)); // Custom
    /// Custom
    final custom = (buildTween(
      GCustom(builder: (child, anim) => FadeTransition(child: child, opacity: anim)),
    ) as AnimatedChild)
        .child as FadeTransition;
    expect(custom.opacity.value, .5);

    //TODO: Add blur
  });
}
