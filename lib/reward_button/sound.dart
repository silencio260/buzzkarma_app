import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:just_audio/just_audio.dart';

final player = AudioPlayer();

void PlayRewardSound() async {
  var duration = await player.setAsset('sounds/reward_sound.mp3');

  player.play();
  if (await Vibration.hasVibrator()) {
    Vibration.vibrate(amplitude: 1000, intensities: [-1, 1]);
  }
}
