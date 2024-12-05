import 'dart:async';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:logging/logging.dart';
import 'load_assets.dart';

class AudioController {
  static final Logger _log = Logger('AudioController');
  late final SoLoud _soloud;
  final Map<String, AudioSource> _preloadedSounds = {};
  SoundHandle? _musicHandle;
  Future<void>? _initializationFuture;

  AudioController() {
    _soloud = SoLoud.instance;
    _initializationFuture = _initialize();
  }
  Future<void> _initialize() async {
    try {
      await initializeSoLoud();
      // Make sure setupLoadAssets is completed before moving on
      setupLoadAssets(_soloud, _preloadedSounds);
      await loadAssets();

      // Verify that sounds were actually loaded
      if (_preloadedSounds.isEmpty) {
        _log.warning('No sounds were preloaded during initialization');
      } else {
        _log.info('Successfully loaded ${_preloadedSounds.length} sounds');
      }
    } catch (e) {
      _log.severe('Failed to complete initialization', e);
      rethrow; // This will make the initialization failure visible
    }
  }

  Future<void> get initialized => _initializationFuture ?? Future.value();

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

  Future<void> playSound(String soundKey) async {
    try {
      await initialized;

      // Add debugging info
      if (_preloadedSounds.isEmpty) {
        _log.warning('No sounds are loaded in the controller');
        return;
      }

      final source = _preloadedSounds[soundKey];
      if (source == null) {
        _log.warning(
            "Sound '$soundKey' not preloaded. Available sounds: ${_preloadedSounds.keys.join(', ')}");
        return;
      }

      await _soloud.play(source);
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
      if (!_soloud.filters.freeverbFilter.isActive) {
        _soloud.filters.freeverbFilter.activate();
      }
      _soloud.filters.freeverbFilter.wet.value = intensity;
      _soloud.filters.freeverbFilter.roomSize.value = intensity;
    } catch (e) {
      _log.severe('Failed to apply reverb filter', e);
    }
  }

  void applyDelayFilter(double intensity) {
    try {
      if (!_soloud.filters.echoFilter.isActive) {
        _soloud.filters.echoFilter.activate();
      }
      _soloud.filters.echoFilter.wet.value = intensity;
      _soloud.filters.echoFilter.delay.value = intensity;
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

  Future<void> startMusic(String musicPath) async {
    try {
      final source = await _soloud.loadAsset(musicPath);
      _musicHandle = await _soloud.play(source);
    } on SoLoudException catch (e) {
      _log.severe("Cannot start music '$musicPath'.", e);
    }
  }
}
