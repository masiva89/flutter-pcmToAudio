import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pcm_sound_demo/data/raw_int.dart';

class JustaudioView extends StatefulWidget {
  const JustaudioView({super.key});

  @override
  State<JustaudioView> createState() => _JustaudioViewState();
}

class _JustaudioViewState extends State<JustaudioView> {
  final player = AudioPlayer();
  bool loaded = false;

  Future<void> initPlayer() async {
    try {
      await player
          .setAudioSource(MyCustomSource(PCM_RAW))
          .timeout(const Duration(seconds: 2));
    } catch (e) {
      print(e);
    }
    setState(() {
      loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    if (loaded) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('PCM Player'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'PCM Player',
              ),
              ElevatedButton(
                onPressed: () {
                  player.play();
                },
                child: const Text('Play'),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}

class MyCustomSource extends StreamAudioSource {
  final List<int> bytes;
  MyCustomSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/wav',
    );
  }
}
