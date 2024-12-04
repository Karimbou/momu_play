import 'dart:async';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:logging/logging.dart';

class AudioController {
  static final Logger _log = Logger('AudioController');
  late final SoLoud _soloud;
  SoundHandle? _musicHandle;

  // Constrctor to init SoLoud
  AudioController() {
    _soloud = SoLoud.instance;
    initializeSoLoud().then((_) => _loadAssets());
  }

  // Soloud gets initialised
  Future<void> initializeSoLoud() async {
    try {
      if (!_soloud.isInitialized) {
        await _soloud.init();
        _soloud.setVisualizationEnabled(false);
        _soloud.setGlobalVolume(1.0);
        _soloud.setMaxActiveVoiceCount(36);
      }
    } catch (e) {
      _log.severe('Failed to initialize audio controller', e);
    }
  }

  // Soloud loading files
  Future<void> _loadAssets() async {
    try {
      final soundPath = await _soloud.loadFile('assets/sounds/');
      // final musicPath = await _soloud.loadAsset('aasets/music/');

      applyAudioEffects();
      playSound(soundPath as String);
    } catch (e) {
      _log.severe('Failed to load asssets into memory', e);
    }
  }

  // PlaySound Function
  Future<void> playSound(String assetKey) async {
    try {
      final source = await _soloud.loadAsset(assetKey);
      await _soloud.play(source);
    } on SoLoudException catch (e) {
      _log.severe("Can not play sound '$assetKey'. Ignoring.", e);
    }
  }

// Apply Audio Effcts at the initial State
  Future<void> applyAudioEffects() async {
    _soloud.filters.echoFilter.activate();
    _soloud.filters.freeverbFilter.activate();

    _soloud.filters.echoFilter.wet.value = 0.0;
    _soloud.filters.echoFilter.delay.value = 0.1;
    _soloud.filters.echoFilter.decay.value = 0.5;

    _soloud.filters.freeverbFilter.wet.value = 0.1;
    _soloud.filters.freeverbFilter.roomSize.value = 0.0;
  }

  void fadeOutMusic() {
    try {
      const fadeLength = Duration(seconds: 3);
      _soloud.fadeVolume(_musicHandle!, 0.0, fadeLength);
      _soloud.scheduleStop(_musicHandle!, fadeLength);
      _musicHandle = null;
    } catch (e) {
      _log.severe('Failed to fade out music', e);
    }
  }

  void applyReverbFilter(double intensity) {
    try {
      _soloud.filters.freeverbFilter.activate();
      _soloud.filters.freeverbFilter.wet.value = 0.5;
      _soloud.filters.freeverbFilter.roomSize.value = 0.5;
    } catch (e) {
      _log.severe('Failed to apply reverb filter', e);
    }
  }

  void applyDelayFilter(double intensity) {
    try {
      _soloud.filters.echoFilter.activate();
      _soloud.filters.echoFilter.wet.value = 0.5;
      _soloud.filters.echoFilter.delay.value = 0.5;
    } catch (e) {
      _log.severe('Failed to apply delay filter', e);
    }
  }

  void removeFilters() {
    try {
      if (_soloud.filters.freeverbFilter.isActive) {
        _soloud.filters.freeverbFilter.deactivate();
      }
      if (_soloud.filters.echoFilter.isActive) {
        _soloud.filters.echoFilter.deactivate();
      }
    } catch (e) {
      _log.severe('Failed to remove filters', e);
    }
  }

  void _stopMusic() {
    if (_musicHandle != null) {
      try {
        _soloud.stop(_musicHandle!);
        _musicHandle = null;
      } catch (e) {
        _log.severe('Failed to stop music', e);
      }
    }
  }

  void _stopAllSounds() {
    try {
      _soloud.deinit();
    } catch (e) {
      _log.severe('Failed to stop all sounds', e);
    }
  }
}




// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.audioController});

//   final AudioController audioController;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// enum Filter {
//   Off,
//   Reverb,
//   Delay,
// }

// class _MyHomePageState extends State<MyHomePage> {
//   static const _gap = SizedBox(height: 16);
//   Filter selectedFilter = Filter.Off;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Flutter SoLoud Demo')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             OutlinedButton(
//               onPressed: () {
//                 widget.audioController.playSound('assets/sounds/pew1.mp3');
//               },
//               child: const Text('Play Sound1'),
//             ),
//             OutlinedButton(
//               onPressed: () {
//                 widget.audioController.playSound('assets/sounds/pew2.mp3');
//               },
//               child: const Text('Play Sound2'),
//             ),
//             _gap,
//             OutlinedButton(
//               onPressed: () {
//                 widget.audioController.startMusic();
//               },
//               child: const Text('Start Music'),
//             ),
//             _gap,
//             OutlinedButton(
//               onPressed: () {
//                 widget.audioController.fadeOutMusic();
//               },
//               child: const Text('Fade Out Music'),
//             ),
//             _gap,
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text('Apply Filter'),
//                 const SizedBox(width: 8),
//                 SegmentedButton<Filter>(
//                   segments: const <ButtonSegment<Filter>>[
//                     ButtonSegment<Filter>(
//                       value: Filter.Reverb,
//                       label: Text('Reverb'),
//                     ),
//                     ButtonSegment<Filter>(
//                       value: Filter.Delay,
//                       label: Text('Delay'),
//                     ),
//                     ButtonSegment<Filter>(
//                       value: Filter.Off,
//                       label: Text('Off'),
//                     ),
//                   ],
//                   selected: {selectedFilter},
//                   onSelectionChanged: (Set<Filter> value) {
//                     setState(() {
//                       selectedFilter = value.first;
//                     });
//                     switch (selectedFilter) {
//                       case Filter.Reverb:
//                         widget.audioController.applyFilterVerb();
//                         break;
//                       case Filter.Delay:
//                         widget.audioController.applyFilterDelay();
//                         break;
//                       case Filter.Off:
//                         widget.audioController.removeFilter();
//                         break;
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
