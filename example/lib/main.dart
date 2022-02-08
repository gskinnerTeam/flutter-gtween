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

class MinSizeRow extends Row {}

class _TweenExamplesState extends State<TweenExamples> {
  GTweenController? _fadeTween0;
  GTweenController? _fadeTween1;
  GTweenController? _fadeTween2;
  GTweenController? _scaleTween0;
  GTweenController? _scaleTween1;
  GTweenController? _moveTween;
  GTweenController? _customTween0;
  GTweenController? _customTween1;
  GTweenController? _headShakeTween;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // Imperative control
              TextButton(
                onPressed: () {
                  _scaleTween0?.restart();
                  _scaleTween1?.restart();
                  _fadeTween0?.restart();
                  _fadeTween1?.restart();
                  _fadeTween2?.restart();
                  _moveTween?.restart();
                  _customTween0?.restart();
                  _customTween1?.restart();
                  _headShakeTween?.restart();
                },
                child: const Text('Run Again'),
              ),

              ///
              Expanded(
                child: Wrap(
                  children: [
                    GTweener([GFade()], child: const FlutterLogo(size: 25)),

                    /// default fade (single shot) w/ extensions
                    const FlutterLogo(size: 50).gTween.fade(),

                    /// controlled fade
                    GTweener(
                      [GFade()],
                      onInit: (controller) => _fadeTween0 = controller,
                      child: const FlutterLogo(size: 25),
                    ),

                    /// Simple controlled-scale with extensions, uses onInit to cache the controller
                    const FlutterLogo(size: 75).gTween.scale().copyWith(onInit: (t) => _scaleTween0 = t),

                    /// Alternate syntax, using [GTween].tween()
                    GScale().tween(const FlutterLogo(size: 75)).copyWith(onInit: (t) => _scaleTween1 = t),

                    /// Head-shake with cached controller
                    GHeadShake().tween(const FlutterLogo(size: 75)).copyWith(onInit: (t) => _headShakeTween = t),

                    /// Custom tween example
                    const FlutterLogo(size: 100).gTween.custom(builder: (_, child, anim) {
                      return Opacity(opacity: anim.value, child: child);
                    }).copyWith(onInit: (t) => _customTween0 = t),

                    /// Complex custom tween
                    /// Normally you'd stick this in method somewhere, like:
                    ///
                    ///     FlutterLogo().gTween.custom(builder: _myCustomAnim),
                    ///
                    const FlutterLogo().gTween.custom(builder: (_, child, anim) {
                      final alignAnim = anim.drive(Tween(begin: Alignment.centerRight, end: Alignment.centerLeft));
                      return FadeTransition(
                          opacity: anim,
                          child: ScaleTransition(
                            scale: anim.drive(Tween(begin: .5, end: 1)), // tween scale from 50% to 100% for example
                            child: AlignTransition(alignment: alignAnim, child: child),
                          ));
                    }).copyWith(onInit: (t) => _customTween1 = t, duration: 5.seconds),

                    /// controlled-move with extensions (from is optional, to is required)
                    const FlutterLogo(size: 75)
                        .gTween
                        .move(from: const Offset(-100, 0), to: const Offset(0, 0), curve: Curves.easeOutBack)
                        .copyWith(onInit: (t) => _moveTween = t, duration: 3.seconds),

                    /// Kitchen sink controllable multi-tween
                    GTweener(
                      [GFade(), GScale(curve: Curves.easeOutBack, from: .8)],
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInCubic,
                      onInit: (c) => _fadeTween1 = c..play(),
                      onUpdate: (_) => print('Update: ${_fadeTween1?.animation.value}'),
                      onComplete: (_) => print('Complete'),
                      autoPlay: false,
                      child: const FlutterLogo(size: 100),
                    ),
                    //
                    /// Kitchen sink with extensions
                    const FlutterLogo(size: 100).gTween.fade().scale(curve: Curves.easeOutBack, from: .8).copyWith(
                          duration: 1.2.seconds,
                          curve: Curves.easeInCubic,
                          onInit: (c) => _fadeTween2 = c..play(),
                          onUpdate: (_) => print('Update: ${_fadeTween2?.animation.value}'),
                          onComplete: (_) => print('Complete'),
                          autoPlay: false,
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
