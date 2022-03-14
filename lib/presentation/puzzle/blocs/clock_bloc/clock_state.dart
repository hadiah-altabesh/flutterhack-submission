part of 'clock_bloc.dart';

enum ClockType { timer, stopwatch }

abstract class ClockState extends Equatable {
  final int duration;
  final ClockType clockType;

  const ClockState({required this.clockType, required this.duration});

  @override
  List<Object> get props => [clockType, duration];
}

class ClockInitial extends ClockState {
  const ClockInitial(ClockType clockType, int duration)
      : super(clockType: clockType, duration: duration);

  @override
  String toString() => 'ClockInitial { duration: $duration }';
}

class ClockRunPause extends ClockState {
  const ClockRunPause(ClockType clockType, int duration)
      : super(clockType: clockType, duration: duration);

  @override
  String toString() => 'ClockRunPause { duration: $duration }';
}

class ClockRunInProgress extends ClockState {
  const ClockRunInProgress(ClockType clockType, int duration)
      : super(clockType: clockType, duration: duration);

  @override
  String toString() => 'ClockRunInProgress { duration: $duration }';
}

class TimerRunComplete extends ClockState {
  const TimerRunComplete() : super(clockType: ClockType.timer, duration: 0);
}
