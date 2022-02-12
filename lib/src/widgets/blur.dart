import 'dart:ui';

import 'package:flutter/material.dart';

class Blur extends StatelessWidget {
  const Blur({Key? key, required this.child, this.blurX = 0, this.blurY = 0, this.strength = 1})
      : assert(strength >= 0 && strength <= 1, 'Strength must be between 0-1'),
        assert(blurX >= 0 && blurY >= 0, 'blurX and blurY can not be negative'),
        super(key: key);
  final Widget child;
  final double blurX;
  final double blurY;
  final double strength;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blurX * strength, sigmaY: blurY * strength, tileMode: TileMode.decal),
      child: child,
    );
  }
}
