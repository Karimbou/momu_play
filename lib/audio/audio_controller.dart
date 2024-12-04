import 'dart:async';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:logging/logging.dart';

class AudioController {
  static final Logger _log = Logger('AudioController');
  late final SoLoud _soloud;
  SoundHandle? _musicHandle;
  final Map<String, AudioSource> _preloadedSounds = {};

  AudioController() {
    _soloud = SoLoud.instance;
    initializeSoLoud().then((_) => _loadAssets());
  }

  Future<void> initializeSoLoud() async {
    try {
      if (!_soloud.isInitialized) {
        await _soloud.init();
        _soloud.setVisualizationEnabled(false);
        _soloud.setGlobalVolume(1.0);
        _soloud.setMaxActiveVoiceCount(36);
      }
    } on SoLoudException catch (e) {
      _log.severe('Failed to initialize audio controller', e);
    }
  }

  Future<void> _loadAssets() async {
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

  Future<void> playSound(String soundKey) async {
    try {
      final source = _preloadedSounds[soundKey];
      if (source != null) {
        await _soloud.play(source);
      } else {
        _log.warning("Sound '$soundKey' not preloaded.");
      }
    } on SoLoudException catch (e) {
      _log.severe("Can not play sound '$soundKey'.", e);
    }
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

  Future<void> startMusic(String musicPath) async {
    try {
      final source = await _soloud.loadAsset(musicPath);
      _musicHandle = await _soloud.play(source);
    } on SoLoudException catch (e) {
      _log.severe("Cannot start music '$musicPath'.", e);
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
}
