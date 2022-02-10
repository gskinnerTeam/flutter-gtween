import 'dart:math';

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
  const TweenExamples({Key? key}) : super(key: key);

  @override
  State<TweenExamples> createState() => _TweenExamplesState();
}

class _TweenExamplesState extends State<TweenExamples> {
  GTweenerController? _fadeTween0;
  GTweenerController? _fadeTween1;
  GTweenerController? _fadeTween2;
  GTweenerController? _scaleTween0;
  GTweenerController? _scaleTween1;
  GTweenerController? _moveTween;
  GTweenerController? _customTween0;
  GTweenerController? _customTween1;
  GTweenerController? _headShakeTween0;
  GTweenerController? _headShakeTween1;
  final List<GTweenerController> _sequencedControllers = [];

  ValueKey<int> _key = const ValueKey(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              ///
              const Text('Single Shot'),
              OutlinedButton(
                onPressed: () => setState(() => _key = ValueKey(Random().nextInt(99999))),
                child: const Text('Clear All State'),
              ),
              Flexible(
                child: Wrap(
                  children: [
                    const GTweener([GFade()], child: FlutterLogo(size: 25)),

                    /// default fade (single shot) w/ extensions
                    const FlutterLogo(size: 50).gTweener.fade(),

                    /// colorize fade with long duration
                    const FlutterLogo(size: 50)
                        .gTweener
                        .colorize(from: Colors.red, to: Colors.black)
                        .withDuration(3.seconds),

                    /// Complex 3-part tween
                    const FlutterLogo(size: 50).gTweener.fade().scale().move(from: const Offset(-40, -40)),

                    /// delays

                    Column(
                      children: const [
                        FlutterLogo(),
                        FlutterLogo(),
                        FlutterLogo(),
                      ].gTweenSequence([const GFade()], interval: 1.seconds),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text('Controlled / Complex'),
              // Imperative control
              OutlinedButton(
                onPressed: () {
                  _scaleTween0?.restart();
                  _scaleTween1?.restart();
                  _fadeTween0?.restart();
                  _fadeTween1?.restart();
                  _fadeTween2?.restart();
                  _moveTween?.restart();
                  _customTween0?.restart();
                  _customTween1?.restart();
                  _headShakeTween0?.restart();
                  _headShakeTween1?.restart();
                  for (var s in _sequencedControllers) {
                    s.restart();
                  }
                },
                child: const Text('.restart()'),
              ),
              Expanded(
                child: Wrap(
                  children: [
                    /// controlled fade
                    GTweener(
                      const [GFade()],
                      onInit: (controller) => _fadeTween0 = controller,
                      child: const FlutterLogo(size: 25),
                    ),

                    /// scale+rotate with extensions, uses onInit to cache the controller
                    const FlutterLogo(size: 75).gTweener.scale().rotate(from: -180).withInit((t) => _scaleTween0 = t),

                    /// Alternate syntax, using [GTween].tween()
                    const GScale().tween(const FlutterLogo(size: 75)).withInit((t) => _scaleTween1 = t),

                    /// Head-shake with cached controller (widget style)
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.blue.shade100,
                      child: GTweener(
                        const [GHeadShake()],
                        autoPlay: false,
                        duration: GHeadShake.defaultDuration,
                        onInit: (controller) => _headShakeTween0 = controller,
                        child: OutlinedButton(
                          onPressed: () => _headShakeTween0?.restart(),
                          child: const Text('Submit'),
                        ),
                      ),
                    ),

                    /// Head-shake with cached controller (extension style)
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.blue.shade100,
                      child: OutlinedButton(
                        onPressed: () => _headShakeTween1?.restart(),
                        child: const Text('Submit'),
                      ).gTweener.headShake().withInit((t) => _headShakeTween1 = t),
                    ),

                    /// Custom tween example
                    const FlutterLogo(size: 100).gTweener.custom(builder: (child, anim) {
                      return Opacity(opacity: anim.value, child: child);
                    }).withInit((t) => _customTween0 = t),

                    /// Complex custom tween
                    /// Normally you'd stick this in method somewhere, like:
                    ///
                    ///     FlutterLogo().gTween.custom(builder: AppAnims.doSomeCrazyStuff),
                    ///
                    SizedBox(
                      width: 200,
                      child: const FlutterLogo(size: 150).gTweener.custom(builder: (child, anim) {
                        final alignAnim = anim.drive(Tween(begin: Alignment.centerRight, end: Alignment.centerLeft));
                        return FadeTransition(
                            opacity: anim,
                            child: ScaleTransition(
                              scale: anim.drive(Tween(begin: .8, end: 1)), // tween scale from 50% to 100% for example
                              child: AlignTransition(alignment: alignAnim, child: child),
                            ));
                      }).copyWith(onInit: (t) => _customTween1 = t, duration: 2.seconds),
                    ),

                    /// controlled-move with extensions
                    const FlutterLogo(size: 75)
                        .gTweener
                        .move(from: const Offset(-100, 0), to: const Offset(0, 0), curve: Curves.easeOutBack)
                        .copyWith(onInit: (t) => _moveTween = t, duration: 3.seconds),

                    /// Kitchen sink controllable multi-tween
                    GTweener(
                      const [GFade(), GScale(curve: Curves.easeOutBack, from: .8)],
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInCubic,
                      onInit: (c) => _fadeTween1 = c..forward(),
                      // onUpdate: (_) => print('Update: ${_fadeTween1?.animation.value}'),
                      // onComplete: (_) => print('Complete'),
                      autoPlay: false,
                      child: const FlutterLogo(size: 100),
                    ),

                    /// Kitchen sink with extensions
                    const FlutterLogo(size: 100).gTweener.fade().scale(curve: Curves.easeOutBack, from: .8).copyWith(
                          duration: 1.2.seconds,
                          curve: Curves.easeInCubic,
                          onInit: (c) => _fadeTween2 = c..forward(),
                          // onUpdate: (_) => print('Update: ${_fadeTween2?.animation.value}'),
                          // onComplete: (_) => print('Complete'),
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
