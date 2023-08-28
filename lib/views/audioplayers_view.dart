import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pcm_sound_demo/utils/buffer_util.dart';

import '../data/raw_int.dart';

class AudioplayersView extends StatefulWidget {
  const AudioplayersView({super.key});

  @override
  State<AudioplayersView> createState() => _AudioplayersViewState();
}

class _AudioplayersViewState extends State<AudioplayersView> {
  final player = AudioPlayer();
  late BytesSource source;
  bool loaded = false;

  Future<void> initPlayer() async {
    Uint8List uint8list = await BufferUtil.pcmToUint8List(PCM_RAW, 16000);
    //Source byteSource = BytesSource(uint8list);
    player.setSource(source);
    setState(() {
      loaded = true;
      source = BytesSource(uint8list);
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
                  player.play(source);
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
