import 'package:video_player/video_player.dart';

class AudioUtils {
  static VideoPlayerController bgAudioController =
      VideoPlayerController.asset('assets/audio/background.mp3',videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
  static VideoPlayerController shotAudioController =
      VideoPlayerController.asset('assets/audio/shoot.mp3',videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
  static VideoPlayerController destroyAudioController =
      VideoPlayerController.asset('assets/audio/destroy.m4a',videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));

  static playBackground() {
    bgAudioController.seekTo(const Duration(seconds: 0)).then((value) {
      bgAudioController.play();
      bgAudioController.setLooping(true);
    });
  }

  static stopBackgroundAudio() async {
    await bgAudioController.pause();
  }

  static playDestroy() {
    destroyAudioController.seekTo(const Duration(seconds: 0)).then((value) {
      destroyAudioController.play();
    });
  }


  static playShot() {
    shotAudioController.seekTo(const Duration(seconds: 0)).then((value) {
      shotAudioController.play();
    });
  }

  static Future initAudio() async {
    await bgAudioController.initialize();
    await shotAudioController.initialize();
    await destroyAudioController.initialize();
  }
}
