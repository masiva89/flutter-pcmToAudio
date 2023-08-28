// ignore_for_file: prefer_const_declarations

import 'package:flutter/material.dart';
import 'package:soundpool/soundpool.dart';

import '../data/raw_int.dart';
import '../utils/buffer_util.dart';

class SoundpoolPlayerView extends StatefulWidget {
  const SoundpoolPlayerView({super.key});

  @override
  State<SoundpoolPlayerView> createState() => _SoundpoolPlayerViewState();
}

class _SoundpoolPlayerViewState extends State<SoundpoolPlayerView> {
  Soundpool pool = Soundpool.fromOptions();
  bool loaded = false;

  Future<void> initRawData() async {
    final pcmBuffer = PCM_RAW;
    /* Codec codec = Codec.;
    final rawData = codec.decode(pcmBuffer); */
    final uint8list = await BufferUtil.pcmToUint8List(pcmBuffer, 16000);
    //final byteData = uint8list.buffer.asByteData();
    int soundId = await pool.loadUint8List(uint8list);
    pool.play(soundId);
    setState(() {
      loaded = true;
    });
    /* final uint16 = Uint16List.fromList(rawData);
    return uint16.buffer.asByteData(); */
  }

  @override
  void initState() {
    super.initState();
    initRawData();
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
                  pool.play(1);
                },
                child: const Text('Play'),
              ),
            ],
          ),
        ),
      );
    }
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
