import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SoundManager {
  late final AudioPlayer _audioPlayer;

  SoundManager() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.setVolume(1.0);
  }

  Future<void> play(String audioPath) async {
    await _audioPlayer.setSource(AssetSource(audioPath));
    await _audioPlayer.resume();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  SoundManager soundManager = SoundManager();
  soundManager.play('sounds/emergency.mp3');
}
