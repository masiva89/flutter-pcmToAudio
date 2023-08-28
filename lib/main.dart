import 'package:flutter/material.dart';
import 'package:pcm_sound_demo/views/fluttersoundplayer_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PCM Players Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 67, 0, 182)),
        useMaterial3: true,
      ),
      home: const FlutterSoundPlayerView(),
    );
  }
}
