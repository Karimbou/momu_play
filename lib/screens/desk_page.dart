import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:momu_play/components/sound_key.dart';
import 'package:momu_play/constants.dart';

class DeskPage extends StatefulWidget {
  final String? title;

  const DeskPage({super.key, required this.title});

  @override
  State<DeskPage> createState() => _DeskPageState();
}

class _DeskPageState extends State<DeskPage> {
  int effectValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            // First Row
            child: Row(
              children: [
                Expanded(
                  child: SoundKey(
                    onPress: () {},
                    colour: kTabColorGreen,
                  ),
                ),
                Expanded(
                  child: SoundKey(
                    onPress: () {},
                    colour: kTabColorBlue,
                  ),
                ),
              ],
            ),
          ),
          // Second Row
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: SoundKey(
                    onPress: () {},
                    colour: kTabColorOrange,
                  ),
                ),
                Expanded(
                  child: SoundKey(
                    onPress: () {},
                    colour: kTabColorPink,
                  ),
                ),
              ],
            ),
          ),
          // Third Row
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: SoundKey(
                    onPress: () {},
                    colour: kTabColorYellow,
                  ),
                ),
                Expanded(
                  child: SoundKey(
                    onPress: () {},
                    colour: kTabColorPurple,
                  ),
                ),
              ],
            ),
          ),
          // Fourth Row
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: SoundKey(
                    onPress: () {},
                    colour: kTabColorWhite,
                  ),
                ),
                Expanded(
                  child: SoundKey(
                    onPress: () {},
                    colour: kTabColorRed,
                  ),
                ),
              ],
            ),
          ),
          // Sliderbottom
          Expanded(
            child: SoundKey(
              colour: kSliderContainerColor,
              cardchild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Filtersectio',
                    style: kSliderTextStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Color(0xFF8D8E98),
                          thumbColor: Color(0xffeb1555),
                          overlayColor: Color(0x29eb1555),
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 18.0),
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 35.0),
                        ),
                        child: Slider(
                          value: effectValue.toDouble(),
                          min: 0.0,
                          max: 1.0,
                          onChanged: (double newValue) {
                            setState(() {
                              effectValue = newValue.round();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
