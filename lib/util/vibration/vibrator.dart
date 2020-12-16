import 'package:vibration/vibration.dart';

class Vibrator {
  static vibrate(
      {int amplitude = -1, int duration = 250, List<int> pattern = const [], List<int> intensities = const []}) {
    Vibration.hasVibrator().then((value) async {
      if (value) {
        bool hasAmplitudeControl = await Vibration.hasAmplitudeControl();

        if (hasAmplitudeControl) {
          Vibration.vibrate(duration: duration, amplitude: amplitude, pattern: pattern, intensities: intensities);
        } else {
          Vibration.vibrate(duration: duration, pattern: pattern);
        }
      }
    });
  }
}
