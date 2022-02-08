import 'package:flutter/material.dart';
import 'package:gtween/gtween.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(home: TweenExamples());
}

class TweenExamples extends StatefulWidget {
  @override
  State<TweenExamples> createState() => _TweenExamplesState();
}

class _TweenExamplesState extends State<TweenExamples> {
  GTweenController? _fadeTween1;
  GTweenController? _fadeTween2;
  GTweenController? _scaleTween;
  GTweenController? _moveTween;
  GTweenController? _customTween;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// default fade (single shot)
            GTweener([GFade()], child: const FlutterLogo(size: 25)),

            /// default fade (single shot) w/ extensions
            const FlutterLogo(size: 50).tween.fade(),

            /// Simple controlled-scale with extensions, uses onInit to cache the controller
            const FlutterLogo(size: 75).tween.scale().copyWith(onInit: (t) => _scaleTween = t),

            /// Custom tween example
            const FlutterLogo(size: 100).tween.tweenBuilder(builder: (_, child, anim) {
              return Opacity(opacity: anim.value, child: child);
            }).copyWith(onInit: (t) => _customTween = t),

            /// controlled-move with extensions (from is optional, to is required)
            const FlutterLogo(size: 75)
                .tween
                .move(from: const Offset(-100, 0), to: const Offset(100, 0), curve: Curves.easeOutBack)
                .copyWith(onInit: (t) => _moveTween = t, duration: Duration(seconds: 3)),

            /// Kitchen sink controllable multi-tween
            GTweener(
              [GFade(), GScale(curve: Curves.easeOutBack, from: .8)],
              duration: const Duration(seconds: 1),
              curve: Curves.easeInCubic,
              onInit: (c) => _fadeTween1 = c..restart(),
              //onUpdate: (_) => print('Update: ${_fadeTween1?.animation.value}'),
              //onComplete: (_) => print('Complete'),
              autoPlay: false,
              child: const FlutterLogo(size: 100),
            ),
            //
            /// Kitchen sink with extensions
            const FlutterLogo(size: 100).tween.fade().scale(curve: Curves.easeOutBack, from: .8).copyWith(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInCubic,
                  onInit: (c) => _fadeTween2 = c..restart(),
                  //onUpdate: (_) => print('Update: ${_fadeTween2?.animation.value}'),
                  //onComplete: (_) => print('Complete'),
                  autoPlay: false,
                ),

            // Imperative control
            TextButton(
              onPressed: () {
                _scaleTween?.restart();
                _fadeTween1?.restart();
                _fadeTween2?.restart();
                _moveTween?.restart();
                _customTween?.restart();
              },
              child: const Text('Run Again'),
            )
          ],
        ),
      ),
    );
  }
}
