import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'audio/audio_controller.dart';

void main() async {
  Logger.root.level = kDebugMode ? Level.FINE : Level.INFO;
  Logger.root.onRecord.listen((record) {
    dev.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
      zone: record.zone,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });

  WidgetsFlutterBinding.ensureInitialized();

  final audioController = AudioController();
  await audioController.initialize();

  runApp(
    MyApp(audioController: audioController),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({required this.audioController, super.key});

  final AudioController audioController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SoLoud Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: MyHomePage(audioController: audioController),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.audioController});

  final AudioController audioController;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum Filter {
  Off,
  Reverb,
  Delay,
}

class _MyHomePageState extends State<MyHomePage> {
  static const _gap = SizedBox(height: 16);
  Filter selectedFilter = Filter.Off;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter SoLoud Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
              onPressed: () {
                widget.audioController.playSound('assets/sounds/pew1.mp3');
              },
              child: const Text('Play Sound1'),
            ),
            OutlinedButton(
              onPressed: () {
                widget.audioController.playSound('assets/sounds/pew2.mp3');
              },
              child: const Text('Play Sound2'),
            ),
            _gap,
            OutlinedButton(
              onPressed: () {
                widget.audioController.startMusic();
              },
              child: const Text('Start Music'),
            ),
            _gap,
            OutlinedButton(
              onPressed: () {
                widget.audioController.fadeOutMusic();
              },
              child: const Text('Fade Out Music'),
            ),
            _gap,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Apply Filter'),
                const SizedBox(width: 8),
                SegmentedButton<Filter>(
                  segments: const <ButtonSegment<Filter>>[
                    ButtonSegment<Filter>(
                      value: Filter.Reverb,
                      label: Text('Reverb'),
                    ),
                    ButtonSegment<Filter>(
                      value: Filter.Delay,
                      label: Text('Delay'),
                    ),
                    ButtonSegment<Filter>(
                      value: Filter.Off,
                      label: Text('Off'),
                    ),
                  ],
                  selected: {selectedFilter},
                  onSelectionChanged: (Set<Filter> value) {
                    setState(() {
                      selectedFilter = value.first;
                    });
                    switch (selectedFilter) {
                      case Filter.Reverb:
                        widget.audioController.applyFilterVerb();
                        break;
                      case Filter.Delay:
                        widget.audioController.applyFilterDelay();
                        break;
                      case Filter.Off:
                        widget.audioController.removeFilter();
                        break;
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
