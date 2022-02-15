import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gtween/gtween.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(home: TweenExamples());
}

class TweenExamples extends StatefulWidget {
  const TweenExamples({Key? key}) : super(key: key);

  @override
  State<TweenExamples> createState() => _TweenExamplesState();
}

class _TweenExamplesState extends State<TweenExamples> {
  GTweenerController? _headShakeTween0;
  GTweenerController? _headShakeTween1;
  final List<GTweenerController> _controllers = [];

  GTweenerController addController(GTweenerController c) {
    _controllers.add(c);
    return c;
  }

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
                onPressed: () => setState(() {
                  _key = ValueKey(Random().nextInt(99999));
                  _controllers.clear();
                }),
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
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text('Controlled / Complex'),
              // Imperative control
              OutlinedButton(
                onPressed: () {
                  for (var s in _controllers) {
                    s.forward(from: 0);
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
                      onInit: addController,
                      child: const FlutterLogo(size: 25),
                    ),

                    /// scale+rotate with extensions, uses onInit to cache the controller
                    const FlutterLogo(size: 75).gTweener.scale().rotate(from: -180).withInit(addController),

                    /// Alternate syntax, using [GTween].tween()
                    const GScale().tween(const FlutterLogo(size: 75)).withInit(addController),

                    /// Test Blur
                    const GBlur(from: Offset(20, 20))
                        .tween(const Text("Blur!", style: TextStyle(fontSize: 22)))
                        .withInit(addController)
                        .withDuration(.5.seconds),

                    /// Sequence
                    Column(
                      children: const [
                        FlutterLogo(),
                        FlutterLogo(),
                        FlutterLogo(),
                      ].gTweenSequence([const GFade()], interval: 1.seconds, onInit: addController),
                    ),

                    /// Head-shake with cached controller (widget style)
                    GTweener(
                      const [GHeadShake()],
                      autoPlay: false,
                      duration: GHeadShake.defaultDuration,
                      onInit: (controller) => _headShakeTween0 = controller,
                      child: OutlinedButton(
                        onPressed: () => _headShakeTween0?.forward(from: 0),
                        child: const Text('Submit'),
                      ),
                    ),

                    /// Head-shake with cached controller (extension style)
                    OutlinedButton(
                      onPressed: () => _headShakeTween1?.forward(from: 0),
                      child: const Text('Submit'),
                    ).gTweener.headShake().withInit((t) => _headShakeTween1 = t),

                    /// Simple custom tween example
                    const FlutterLogo(size: 100).gTweener.custom(builder: (child, anim) {
                      return FadeTransition(opacity: anim, child: child);
                    }).withInit(addController),

                    /// Complex custom tween
                    /// Normally you'd stick this in method somewhere, like:
                    ///
                    ///     FlutterLogo().gTween.custom(builder: () => AppTweens.customAnim1(widget.data)),
                    ///
                    const FlutterLogo(size: 150).gTweener.withDuration(2.seconds).custom(builder: (child, anim) {
                      final alignAnim = anim.drive(Tween(begin: Alignment.centerRight, end: Alignment.centerLeft));
                      return FadeTransition(
                          opacity: anim,
                          child: ScaleTransition(
                            scale: anim.drive(Tween(begin: .8, end: 1)), // tween scale from 50% to 100% for example
                            child: AlignTransition(alignment: alignAnim, child: child),
                          ));
                    }).withInit(addController),

                    /// controlled-move with extensions
                    const FlutterLogo(size: 75)
                        .gTweener
                        .move(from: const Offset(-100, 0), to: const Offset(0, 0), curve: Curves.easeOutBack)
                        .copyWith(onInit: addController, duration: 3.seconds),

                    /// Kitchen sink controllable multi-tween
                    GTweener(
                      const [GFade(), GScale(curve: Curves.easeOutBack, from: .8)],
                      delay: .5.seconds,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInCubic,
                      onInit: (c) => addController(c)..forward(),
                      // onUpdate: (_) => print('Update: ${_fadeTween1?.animation.value}'),
                      // onComplete: (_) => print('Complete'),
                      autoPlay: false,
                      child: const FlutterLogo(size: 100),
                    ),

                    /// Kitchen sink with extensions
                    const FlutterLogo(size: 100).gTweener.fade().scale(curve: Curves.easeOutBack, from: .8).copyWith(
                          duration: 1.2.seconds,
                          delay: .5.seconds,
                          curve: Curves.easeInCubic,
                          onInit: (c) => addController(c)..forward(),
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
