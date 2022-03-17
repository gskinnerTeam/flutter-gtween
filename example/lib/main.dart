import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gtween/gtween.dart';
import 'package:statsfl/statsfl.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoExample extends StatefulWidget {
  const VideoExample({Key? key}) : super(key: key);

  @override
  State<VideoExample> createState() => _VideoExampleState();
}

class _VideoExampleState extends State<VideoExample> {
  final _controller = YoutubePlayerController(
    initialVideoId: '1AxXF038-lY',
    params: YoutubePlayerParams(
      autoPlay: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube Player IFrame Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          FlutterLogo(size: 200),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: YoutubePlayerIFrame(controller: _controller),
            ),
          ),
          Positioned(right: 0, bottom: 0, child: FlutterLogo(size: 200)),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StatsFl(
        totalTime: 20,
        sampleTime: 2,
        width: 800,
        child: const MaterialApp(
          home: VideoExample(),
          //home: TweenExamples(),
          // home: Material(child: Benchmark()),
        ),
      );
}

class Benchmark extends StatefulWidget {
  const Benchmark({Key? key}) : super(key: key);
  @override
  _BenchmarkState createState() => _BenchmarkState();
}

class _BenchmarkState extends State<Benchmark> {
  double _tweenSliderValue = .2;
  bool _enableRendering = false;
  bool _useGTween = false;

  int get _tweenCount => 10 + (_tweenSliderValue * 5000).round();
  @override
  Widget build(BuildContext context) {
    final rnd = Random(0);
    return Center(
      child: SizedBox(
        width: 400,
        height: 400,
        child: Stack(children: [
          ...List.generate(_tweenCount, (index) {
            return Positioned(
              top: 20.0 + rnd.nextInt(300),
              left: 20.0 + rnd.nextInt(300),
              child: Opacity(opacity: _enableRendering ? 1 : 0, child: _buildLogo()),
            );
          }),
          Column(
            children: [
              CheckboxListTile(
                title: Text('Show Tweens'),
                value: _enableRendering,
                onChanged: _handleShowTweensToggled,
              ),
              CheckboxListTile(
                title: Text('use gtween'),
                value: _useGTween,
                onChanged: _handleUseGTweenToggled,
              ),
              Row(
                children: [
                  Expanded(child: Slider(value: _tweenSliderValue, onChanged: _handleSliderChanged)),
                  Text('$_tweenCount'),
                ],
              ),
            ],
          )
        ]),
      ),
    );
  }

  StatefulWidget _buildLogo() => !_useGTween
      ? _FadeInOut()
      : const FlutterLogo().gTweener.fade().withInit(
            (controller) => controller.animation.repeat(reverse: true),
          );

  void _handleSliderChanged(v) => setState(() => _tweenSliderValue = v);
  void _handleShowTweensToggled(_) => setState(() => _enableRendering = !_enableRendering);
  void _handleUseGTweenToggled(_) => setState(() => _useGTween = !_useGTween);
}

class _FadeInOut extends StatefulWidget {
  @override
  __FadeInOutState createState() => __FadeInOutState();
}

class __FadeInOutState extends State<_FadeInOut> with SingleTickerProviderStateMixin {
  late final _anim = AnimationController(vsync: this, duration: .3.seconds)..repeat(reverse: true);

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(opacity: _anim, child: const FlutterLogo());
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
                    /// simple fade (single shot), widget style
                    GTweener([GFade()], child: const FlutterLogo(size: 25)),

                    /// simple fade (single shot) w/ extension style
                    const FlutterLogo(size: 50).gTweener.fade(to: 0),

                    /// simple fade (single shot) w/ .tween() shortcut style
                    GFade().tween(const FlutterLogo(size: 50)),

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
                      [GFade()],
                      onInit: addController,
                      child: const FlutterLogo(size: 25),
                    ),

                    /// scale+rotate with extensions, uses onInit to cache the controller
                    const FlutterLogo(size: 75).gTweener.scale().rotate(from: -180).withInit(addController),

                    /// Alternate syntax, using [GTween].tween()
                    GScale().tween(const FlutterLogo(size: 75)).withInit(addController),

                    /// Test Blur
                    GBlur(from: Offset(20, 20))
                        .tween(const Text("Blur!", style: TextStyle(fontSize: 22)))
                        .withInit(addController)
                        .withDuration(.5.seconds),

                    /// Sequence
                    Column(
                      children: const [
                        FlutterLogo(),
                        FlutterLogo(),
                        FlutterLogo(),
                      ].gTweenInterval([GFade()], interval: 1.seconds, onInit: addController),
                    ),

                    /// Head-shake with cached controller (widget style)
                    GTweener(
                      [GHeadShake()],
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
                      [GFade(), GScale(curve: Curves.easeOutBack, from: .8)],
                      delay: .5.seconds,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInCubic,
                      onInit: (c) => addController(c)..forward(),
                      onUpdate: (c) => print('Update: ${c.animation.value}'),
                      onComplete: (_) => print('Complete'),
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
