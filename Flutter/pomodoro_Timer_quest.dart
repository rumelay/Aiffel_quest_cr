import 'dart:async'; // 타이머 기능을 사용하기 위해 추가

void main() {
  PomodoroTimer timer = PomodoroTimer();
  timer.startPomodoro(); // 타이머 시작
}

class PomodoroTimer {
  int workDuration = 25 * 60; // 25분 작업 시간을 초로 변환
  int shortBreakDuration = 5 * 60; // 5분 휴식 시간을 초로 변환
  int longBreakDuration = 15 * 60; // 15분 휴식 시간을 초로 변환
  int cycle = 0; // 몇 번째 사이클인지 추적하는 변수
  Timer? _timer; // 주기적으로 시간을 체크할 타이머 변수

  // Pomodoro 타이머 시작
  void startPomodoro() {
    print("Pomodoro 타이머를 시작합니다.");
    _startWork(); // 작업 시간을 먼저 시작
  }

  // 25분 작업 시작
  void _startWork() {
    cycle++; // 사이클을 증가
    print("작업 사이클 $cycle을 시작합니다.");
    _startTimer(workDuration, () {
      print('작업 시간이 종료되었습니다. 휴식 시간을 시작합니다.');
      // 4번째 사이클마다 긴 휴식, 그 외에는 짧은 휴식
      if (cycle % 4 == 0) {
        _startBreak(longBreakDuration); // 긴 휴식 시작
      } else {
        _startBreak(shortBreakDuration); // 짧은 휴식 시작
      }
    });
  }

  // 휴식 시작
  void _startBreak(int breakDuration) {
    print('휴식 시간 시작: ${breakDuration ~/ 60}분');
    _startTimer(breakDuration, () {
      print('휴식 시간이 끝났습니다. 다시 작업을 시작합니다.');
      _startWork(); // 휴식이 끝나면 다시 작업 시작
    });
  }

  // 타이머 시작 함수
  void _startTimer(int seconds, Function onTimerEnd) {
    int remainingTime = seconds; // 남은 시간을 초 단위로 설정
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (remainingTime > 0) {
        remainingTime--; // 1초씩 줄어듦
        int minutes = remainingTime ~/ 60; // 남은 시간 분 단위
        int secs = remainingTime % 60; // 남은 시간 초 단위
        // 현재 남은 시간을 출력 (00:00 형식)
        print(
            'flutter: ${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}');
      } else {
        timer.cancel(); // 타이머 종료
        onTimerEnd(); // 시간이 다 끝나면 콜백 실행
      }
    });
  }
}
