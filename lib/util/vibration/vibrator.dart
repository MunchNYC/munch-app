import 'package:vibration/vibration.dart';

class Vibrator {
  static vibrate(int amplitude, {int duration = 250}) {
    Vibration.hasVibrator().then((value) async {
      if (value) {
        bool hasAmplitudeControl = await Vibration.hasAmplitudeControl();

        if (hasAmplitudeControl) {
          Vibration.vibrate(duration: duration, amplitude: amplitude);
        } else {
          Vibration.vibrate(duration: duration);
        }
      }
    });
  }
}
