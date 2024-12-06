// Import necessary Flutter packages and custom controllers
import 'package:flutter/material.dart';
import 'package:momu_play/audio/audio_controller.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

// StatefulWidget for settings page that can update its state
class SettingsPage extends StatefulWidget {
  // AudioController instance passed from parent widget
  final AudioController audioController;

  // Constructor requiring audioController
  const SettingsPage({
    super.key, // Key for widget identification
    required this.audioController,
  });

  // Create the mutable state for this widget
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

// The mutable state for the SettingsPage
class _SettingsPageState extends State<SettingsPage> {
  // Variables to store current values of audio effects
  double _reverbWet = 0.1; // How much reverb effect is applied
  double _reverbRoomSize = 0.1; // Size of virtual room for reverb
  double _delayWet = 0.1; // How much delay effect is applied
  double _delayTime = 0.1; // Time between sound repetitions
  double _delayDecay = 0.5; // How quickly the delay fades out

  // Called when this widget is inserted into the tree
  @override
  void initState() {
    super.initState();
    _loadCurrentSettings(); // Load current audio settings when page opens
  }

  // Load the current audio settings from the audio controller
  void _loadCurrentSettings() {
    final SoLoud soloud = widget.audioController.soloud;
    setState(() {
      // Update state with current reverb wet value
      _reverbWet = soloud.filters.freeverbFilter.wet.value;
    });
  }

  // Build the settings UI for audio filters
  Widget _buildFilterSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Reverb section
        const Text('Reverb Settings', style: TextStyle(fontSize: 20)),
        // Slider for reverb wet level
        _buildSlider(
          'Wet',
          _reverbWet,
          (value) {
            setState(() {
              _reverbWet = value;
              // Update the actual audio filter
              widget.audioController.soloud.filters.freeverbFilter.wet.value =
                  value;
            });
          },
        ),
        // Slider for reverb room size
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
        const SizedBox(height: 20), // Spacing between sections

        // Delay section
        const Text('Delay Settings', style: TextStyle(fontSize: 20)),
        // Slider for delay wet level
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
        // Slider for delay time
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
        // Slider for delay decay
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

  // Helper method to build a consistent slider with label
  Widget _buildSlider(String label, double value, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label), // Label above slider
        Slider(
          value: value, // Current value
          min: 0.1, // Minimum value
          max: 1.0, // Maximum value
          onChanged: onChanged, // Callback when slider value changes
        ),
      ],
    );
  }

  // Build the main UI for the settings page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top app bar
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      // Main content in a scrollable container
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Padding around all content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterSettings(), // Add the filter settings UI
          ],
        ),
      ),
    );
  }
}
