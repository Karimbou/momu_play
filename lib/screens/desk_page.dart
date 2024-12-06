import 'package:flutter/material.dart';
import 'package:momu_play/components/sound_key.dart';
import 'package:momu_play/constants.dart';
import 'package:momu_play/audio/audio_controller.dart';
import 'settings_page.dart';

/// DeskPage is the main screen of the app where users can play sounds and apply effects
class DeskPage extends StatefulWidget {
  final String title;
  final AudioController audioController;

  const DeskPage({
    super.key,
    required this.title,
    required this.audioController,
  });
  @override
  State<DeskPage> createState() => _DeskPageState();
}

/// Enum to represent the different filter types available
enum Filter { off, reverb, delay }

class _DeskPageState extends State<DeskPage> {
  // Current effect intensity value (0.1 to 1.0)
  double effectValue = 0.1;
  // Currently selected audio filter
  Filter selectedFilter = Filter.off;

  @override
  void initState() {
    super.initState();
    // Wait for audio controller to initialize
    widget.audioController.initialized.then((_) {
      if (mounted) setState(() {});
    });
  }

  /// Handles changes in filter selection from the segmented button
  void _handleFilterChange(Set<Filter> value) {
    setState(() {
      selectedFilter = value.first;
      _applyFilter();
    });
  }

  /// Applies the selected filter with current effect value
  void _applyFilter() {
    switch (selectedFilter) {
      case Filter.reverb:
        widget.audioController.applyReverbFilter(effectValue);
        break;
      case Filter.delay:
        widget.audioController.applyDelayFilter(effectValue);
        break;
      case Filter.off:
        widget.audioController.removeFilters();
        break;
    }
  }

  /// Builds a row of sound keys based on provided configurations
  Widget _buildSoundKeyRow(List<SoundKeyConfig> configs) {
    return Expanded(
      child: Row(
        children: configs
            .map((config) => Expanded(
                  child: SoundKey(
                    onPress: () => config.soundPath != null
                        ? widget.audioController.playSound(config.soundPath!)
                        : null,
                    colour: config.color,
                  ),
                ))
            .toList(),
      ),
    );
  }

  /// Builds the filter control section including title, buttons and slider
  Widget _buildFilterSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              'Filter Section',
              style: kSliderTextStyle,
            ),
          ),
          Expanded(
            child: _buildFilterButtons(),
          ),
          Expanded(child: _buildEffectSlider()),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  /// Builds the segmented button for filter selection
  Widget _buildFilterButtons() {
    return SegmentedButtonTheme(
      data: SegmentedButtonTheme.of(context).copyWith(
        style: const ButtonStyle(
          alignment: Alignment.center,
        ),
      ),
      child: SegmentedButton<Filter>(
        segments: const <ButtonSegment<Filter>>[
          ButtonSegment<Filter>(
            value: Filter.reverb,
            label: Text('Reverb'),
          ),
          ButtonSegment<Filter>(
            value: Filter.delay,
            label: Text('Delay'),
          ),
          ButtonSegment<Filter>(
            value: Filter.off,
            label: Text('Off'),
          ),
        ],
        selected: {selectedFilter},
        onSelectionChanged: _handleFilterChange,
      ),
    );
  }

  /// Builds the slider for controlling effect intensity
  Widget _buildEffectSlider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.white,
        inactiveTrackColor: const Color(0xFF8D8E98),
        thumbColor: const Color(0xffeb1555),
        overlayColor: const Color(0x29eb1555),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 18.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 35.0),
      ),
      child: Slider(
        value: effectValue,
        min: 0.1,
        max: 1.0,
        onChanged: (double newValue) {
          setState(() {
            effectValue = newValue;
            _applyFilter();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final soundKeyConfigs = [
      [
        const SoundKeyConfig(color: kTabColorGreen, soundPath: 'wurli_c'),
        const SoundKeyConfig(color: kTabColorBlue, soundPath: 'wurli_d'),
      ],
      [
        const SoundKeyConfig(color: kTabColorOrange, soundPath: 'wurli_e'),
        const SoundKeyConfig(color: kTabColorPink, soundPath: 'wurli_f'),
      ],
      [
        const SoundKeyConfig(color: kTabColorYellow, soundPath: 'wurli_g'),
        const SoundKeyConfig(color: kTabColorPurple, soundPath: 'wurli_a'),
      ],
      [
        const SoundKeyConfig(color: kTabColorWhite, soundPath: 'wurli_b'),
        const SoundKeyConfig(color: kTabColorRed, soundPath: 'wurli_c_oc'),
      ],
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    audioController: widget.audioController,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ...soundKeyConfigs.map(_buildSoundKeyRow),
          _buildFilterSection(),
        ],
      ),
    );
  }
}
