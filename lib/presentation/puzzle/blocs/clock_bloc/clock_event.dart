part of 'clock_bloc.dart';

abstract class ClockEvent extends Equatable {
  const ClockEvent();

  @override
  List<Object> get props => [];
}

class ClockStarted extends ClockEvent {
  const ClockStarted({required this.clockType, required this.duration});
  final int duration;
  final ClockType clockType;
}

class ClockPaused extends ClockEvent {
  const ClockPaused();
}

class ClockResumed extends ClockEvent {
  const ClockResumed();
}

class ClockReset extends ClockEvent {
  const ClockReset();
}

class ClockTicked extends ClockEvent {
  const ClockTicked({required this.duration});
  final int duration;

  @override
  List<Object> get props => [duration];
}
