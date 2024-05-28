import 'package:just_audio/just_audio.dart';

class SoundManager {
  late final AudioPlayer _audioPlayer;

  SoundManager() {
    _audioPlayer = AudioPlayer();
  }

  Future<void> playSong() async {
    await _audioPlayer.setAsset('assets/sounds/emergency.mp3');
    await _audioPlayer.play();
  }

  Future<void> stopSong() async {
    await _audioPlayer.stop();
  }
}
