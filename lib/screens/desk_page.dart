import 'package:flutter/material.dart';
import 'package:momu_play/components/sound_key.dart';
import 'package:momu_play/constants.dart';
import 'package:momu_play/audio/audio_controller.dart';

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

enum Filter { off, reverb, delay }

class _DeskPageState extends State<DeskPage> {
  double effectValue = 0.0;
  Filter selectedFilter = Filter.off;

  void _handleFilterChange(Set<Filter> value) {
    setState(() {
      selectedFilter = value.first;
    });

    switch (selectedFilter) {
      case Filter.reverb:
        widget.audioController.applyReverbFilter(0);
        break;
      case Filter.delay:
        widget.audioController.applyDelayFilter(0);
        break;
      case Filter.off:
        widget.audioController.removeFilters();
        break;
    }
  }

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

  Widget _buildFilterSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: const Text(
              'Filter Section',
              style: kSliderTextStyle,
            ),
          ),
          Expanded(
            child: _buildFilterButtons(),
          ),
          Expanded(child: _buildEffectSlider()),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

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
        min: 0.0,
        max: 1.0,
        onChanged: (double newValue) {
          setState(() {
            effectValue = newValue;
            _handleFilterChange({selectedFilter});
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final soundKeyConfigs = [
      [
        SoundKeyConfig(
            color: kTabColorGreen, soundPath: 'assets/sounds/note1.wav'),
        SoundKeyConfig(
            color: kTabColorBlue, soundPath: 'assets/sounds/note2.wav'),
      ],
      [
        SoundKeyConfig(
            color: kTabColorOrange, soundPath: 'assets/sounds/note3.wav'),
        SoundKeyConfig(
            color: kTabColorPink, soundPath: 'assets/sounds/note4.wav'),
      ],
      [
        SoundKeyConfig(
            color: kTabColorYellow, soundPath: 'assets/sounds/note5.wav'),
        SoundKeyConfig(
            color: kTabColorPurple, soundPath: 'assets/sounds/note6.wav'),
      ],
      [
        SoundKeyConfig(
            color: kTabColorWhite, soundPath: 'assets/sounds/note7.wav'),
        SoundKeyConfig(
            color: kTabColorRed, soundPath: 'assets/sounds/pew1.mp3'),
      ],
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
