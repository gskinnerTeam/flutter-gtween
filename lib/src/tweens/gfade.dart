import 'package:flutter/material.dart';
import 'package:gtween/gtween.dart';

class GFade extends GTween<double> {
  const GFade({double from = 0, double to = 1, Curve? curve}) : super(from: from, to: to, curve: curve);

  @override
  Widget build(Widget child, Animation<double> anim) {
    return FadeTransition(opacity: tweenAndCurveAnim(anim), child: child);
  }
}

extension GFadeExtension on GTweener {
  GTweener fade({double from = 0, double to = 1, Curve? curve}) {
    return addTween(GFade(curve: curve, from: from, to: to));
  }
}

class MinSizeRow extends Row {
  MinSizeRow({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline, // NO DEFAULT: we don't know what the text's baseline should be
    List<Widget> children = const <Widget>[],
  }) : super(
          children: children,
          key: key,
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          textDirection: textDirection,
          verticalDirection: verticalDirection,
          textBaseline: textBaseline,
        );
}
