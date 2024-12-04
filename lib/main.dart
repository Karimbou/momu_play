import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:momu_play/screens/desk_page.dart';

import 'audio/audio_controller.dart';
import 'constants.dart';

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
  await audioController.initializeSoLoud();

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
        title: kAppName,
        theme: ThemeData.dark(
          useMaterial3: true,
        ).copyWith(
          primaryColor: const Color(0xFF0A0E21),
          scaffoldBackgroundColor: const Color(0xFF0A0E21),
        ),
        home: // MyHomePage(audioController: audioController),
            DeskPage(
          title: kAppName,
          audioController: audioController,
        ));
  }
}
