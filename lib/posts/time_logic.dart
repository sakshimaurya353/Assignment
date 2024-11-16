import 'dart:async';

class PostTimer {
  int duration; // Remaining duration in seconds
  bool isPaused; // Timer paused state
  Timer? _timer; // Internal timer

  PostTimer(this.duration, {this.isPaused = false});

  void start(Function onTick) {
    if (!isPaused && _timer == null) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (duration > 0) {
          duration--;
          onTick();
        } else {
          _timer?.cancel();
        }
      });
    }
  }

  void pause() {
    isPaused = true;
    _timer?.cancel();
    _timer = null;
  }

  void resume(Function onTick) {
    isPaused = false;
    start(onTick);
  }

  void dispose() {
    _timer?.cancel();
  }
}
