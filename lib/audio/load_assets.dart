import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:logging/logging.dart';

final Logger _log = Logger('AudioController');
final Map<String, AudioSource> _preloadedSounds = {};
late final SoLoud _soloud;

void setupLoadAssets(SoLoud soloud, Map<String, AudioSource> preloadedSounds) {
  _soloud = soloud;
  _preloadedSounds.clear();
  _preloadedSounds.addAll(preloadedSounds);
}

Future<void> loadAssets() async {
  try {
    _preloadedSounds['note1'] =
        await _soloud.loadAsset('assets/sounds/note1.wav');
    _preloadedSounds['note2'] =
        await _soloud.loadAsset('assets/sounds/note2.wav');
    _preloadedSounds['note3'] =
        await _soloud.loadAsset('assets/sounds/note3.wav');
    _preloadedSounds['note4'] =
        await _soloud.loadAsset('assets/sounds/note4.wav');
    _preloadedSounds['note5'] =
        await _soloud.loadAsset('assets/sounds/note5.wav');
    _preloadedSounds['note6'] =
        await _soloud.loadAsset('assets/sounds/note6.wav');
    _preloadedSounds['note7'] =
        await _soloud.loadAsset('assets/sounds/note7.wav');
    _preloadedSounds['pew1'] =
        await _soloud.loadAsset('assets/sounds/pew1.mp3');

    applyInitialAudioEffects();
  } on SoLoudException catch (e) {
    _log.severe('Failed to load assets into memory', e);
  }
}

void applyInitialAudioEffects() {
  _soloud.filters.echoFilter.activate();
  _soloud.filters.freeverbFilter.activate();

  _soloud.filters.echoFilter.wet.value = 0.0;
  _soloud.filters.echoFilter.delay.value = 0.1;
  _soloud.filters.echoFilter.decay.value = 0.5;

  _soloud.filters.freeverbFilter.wet.value = 0.1;
  _soloud.filters.freeverbFilter.roomSize.value = 0.0;
}
