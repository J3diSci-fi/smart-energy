import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  late final AudioPlayer _audioPlayer;
  late final AssetSource _audioSource;

  SoundManager() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.setVolume(1.0);

    _audioSource = AssetSource('sounds/emergency.mp3');
  }

  Future<void> playSongLoop() async {
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.seek(Duration.zero);
    await _audioPlayer.play(_audioSource);
  }

  Future<void> playSong() async {
    await _audioPlayer.seek(Duration.zero);
    await _audioPlayer.play(_audioSource);
  }

  Future<void> stopSong() async {
    await _audioPlayer.stop();
  }
}