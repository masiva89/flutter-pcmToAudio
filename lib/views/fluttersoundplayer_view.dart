import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:pcm_sound_demo/utils/buffer_util.dart';
import 'package:pcm_sound_demo/data/raw_int.dart';

class FlutterSoundPlayerView extends StatefulWidget {
  const FlutterSoundPlayerView({super.key});

  @override
  State<FlutterSoundPlayerView> createState() => _FlutterSoundPlayerViewState();
}

class _FlutterSoundPlayerViewState extends State<FlutterSoundPlayerView> {
  FlutterSoundPlayer playerModule = FlutterSoundPlayer();

  StreamSubscription<PlaybackDisposition>? _playerSubscription;

  String positionText = '00:00:00';

  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;

  Future<void> seekToPlayer(int milliSecs) async {
    //playerModule.logger.d('-->seekToPlayer');
    try {
      if (playerModule.isPlaying) {
        await playerModule.seekToPlayer(Duration(milliseconds: milliSecs));
      }
    } on Exception catch (err) {
      playerModule.logger.e('error: $err');
    }
    setState(() {});
    //playerModule.logger.d('<--seekToPlayer');
  }

  void _addListeners() {
    cancelPlayerSubscriptions();
    _playerSubscription = playerModule.onProgress!.listen((e) {
      maxDuration = e.duration.inMilliseconds.toDouble();
      if (maxDuration <= 0) maxDuration = 0.0;

      sliderCurrentPosition = e.position.inMilliseconds.toDouble();
      if (sliderCurrentPosition < 0.0) {
        sliderCurrentPosition = 0.0;
      }

      var date = DateTime.fromMillisecondsSinceEpoch(e.position.inMilliseconds,
          isUtc: true);
      var txt = date.toIso8601String().substring(11, 19);
      setState(() {
        positionText = txt.substring(0, 8);
      });
    });
  }

  void _startPlayer() async {
    List<int> rawData = PCM_RAW;
    Uint8List uint8 = await BufferUtil.pcmToUint8List(rawData, 16000);

    await playerModule.startPlayer(
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: 16000,
      fromDataBuffer: uint8,
    );
    //_addListeners();
    //await stopPlayer();
  }

  Future<void> stopPlayer() async {
    try {
      await playerModule.stopPlayer();
      playerModule.logger.d('stopPlayer');
      if (_playerSubscription != null) {
        await _playerSubscription!.cancel();
        _playerSubscription = null;
      }
      sliderCurrentPosition = 0.0;
      positionText = '00:00:00';
    } on Exception catch (err) {
      playerModule.logger.d('error: $err');
    }
    setState(() {});
  }

  Future<void> _initializeExample() async {
    await playerModule.closePlayer();
    await playerModule.openPlayer().then((value) {
      setState(() {
        playerModule = value!;
      });
    });
    await playerModule.setSubscriptionDuration(const Duration(milliseconds: 1));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeExample();
    });
  }

  @override
  void dispose() {
    super.dispose();
    cancelPlayerSubscriptions();
  }

  void cancelPlayerSubscriptions() {
    if (_playerSubscription != null) {
      _playerSubscription!.cancel();
      _playerSubscription = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Sound Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Flutter Sound Player',
            ),
            ElevatedButton(
              onPressed: () async {
                _startPlayer();
              },
              child: const Text('Play'),
            ),
            Text(positionText),
            Container(
                height: 30.0,
                child: Slider(
                    value: min(sliderCurrentPosition, maxDuration),
                    min: 0.0,
                    max: maxDuration,
                    onChanged: (value) async {
                      await seekToPlayer(value.toInt());
                    },
                    divisions: maxDuration == 0.0 ? 1 : maxDuration.toInt())),
          ],
        ),
      ),
    );
  }
}
