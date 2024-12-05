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
    _preloadedSounds['wurli_c'] =
        await _soloud.loadAsset('assets/sounds/wurli/wurli_c.wav');
    _preloadedSounds['wurli_d'] =
        await _soloud.loadAsset('assets/sounds/wurli/wurli_d.wav');
    _preloadedSounds['wurli_e'] =
        await _soloud.loadAsset('assets/sounds/wurli/wurli_e.wav');
    _preloadedSounds['wurli_f'] =
        await _soloud.loadAsset('assets/sounds/wurli/wurli_f.wav');
    _preloadedSounds['wurli_g'] =
        await _soloud.loadAsset('assets/sounds/wurli/wurli_g.wav');
    _preloadedSounds['wurli_a'] =
        await _soloud.loadAsset('assets/sounds/wurli/wurli_a.wav');
    _preloadedSounds['wurli_b'] =
        await _soloud.loadAsset('assets/sounds/wurli/wurli_b.wav');
    _preloadedSounds['wurli_c_oc'] =
        await _soloud.loadAsset('assets/sounds/wurli/wurli_c_oc.wav');

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
