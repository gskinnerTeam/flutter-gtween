import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gtween/gtween.dart';

void main() {
  testWidgets('sequence test', (tester) async {
    /// maxItems of 2, no-delay, use default duration of 100ms
    var widgets = [
      const FlutterLogo(),
      const FlutterLogo(),
      const FlutterLogo(),
    ].gTweenSequence([const GFade()], maxIndex: 2);

    expect((widgets[0] as GTweener).tweens.first is GFade, true);
    expect(((widgets[0] as GTweener).delay), 0.seconds);
    expect(((widgets[1] as GTweener).delay), .1.seconds);
    expect(((widgets[2] as GTweener).delay), 0.seconds);

    // delay with non-default interval
    widgets = [
      const FlutterLogo(),
      const FlutterLogo(),
    ].gTweenSequence([const GFade()], delay: 1.seconds, interval: .5.seconds);

    expect(((widgets[0] as GTweener).delay), 1.seconds);
    expect(((widgets[1] as GTweener).delay), 1.seconds + .5.seconds);
  });
}
