import 'package:flutter/material.dart';
import 'package:momu_play/audio/audio_controller.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class SettingsPage extends StatefulWidget {
  final AudioController audioController;

  const SettingsPage({
    super.key,
    required this.audioController,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double _reverbWet = 0.1;
  double _reverbRoomSize = 0.1;
  double _delayWet = 0.1;
  double _delayTime = 0.1;
  double _delayDecay = 0.5;

  @override
  void initState() {
    super.initState();
    _loadCurrentSettings();
  }

  void _loadCurrentSettings() {
    final SoLoud soloud = widget.audioController.soloud;
    setState(() {
      _reverbWet = soloud.filters.freeverbFilter.wet.value;
    });
  }

  Widget _buildFilterSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Reverb Settings', style: TextStyle(fontSize: 20)),
        _buildSlider(
          'Wet',
          _reverbWet,
          (value) {
            setState(() {
              _reverbWet = value;
              widget.audioController.soloud.filters.freeverbFilter.wet.value =
                  value;
            });
          },
        ),
        _buildSlider(
          'Room Size',
          _reverbRoomSize,
          (value) {
            setState(() {
              _reverbRoomSize = value;
              widget.audioController.soloud.filters.freeverbFilter.roomSize
                  .value = value;
            });
          },
        ),
        const SizedBox(height: 20),
        const Text('Delay Settings', style: TextStyle(fontSize: 20)),
        _buildSlider(
          'Wet',
          _delayWet,
          (value) {
            setState(() {
              _delayWet = value;
              widget.audioController.soloud.filters.echoFilter.wet.value =
                  value;
            });
          },
        ),
        _buildSlider(
          'Delay Time',
          _delayTime,
          (value) {
            setState(() {
              _delayTime = value;
              widget.audioController.soloud.filters.echoFilter.delay.value =
                  value;
            });
          },
        ),
        _buildSlider(
          'Decay',
          _delayDecay,
          (value) {
            setState(() {
              _delayDecay = value;
              widget.audioController.soloud.filters.echoFilter.decay.value =
                  value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSlider(String label, double value, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Slider(
          value: value,
          min: 0.1,
          max: 1.0,
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterSettings(),
          ],
        ),
      ),
    );
  }
}
