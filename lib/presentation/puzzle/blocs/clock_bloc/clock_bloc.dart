import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:slide_puzzle/utils/ticker.dart';

part 'clock_event.dart';
part 'clock_state.dart';

class ClockBloc extends Bloc<ClockEvent, ClockState> {
  final Ticker _ticker;
  static const int _duration = 60;
  int _stopwatch = 0;

  StreamSubscription<int>? _tickerSubscription;

  ClockBloc({required Ticker ticker})
      : _ticker = ticker,
        super(ClockInitial(ClockType.stopwatch, 0)) {
    // super(ClockInitial(duration)) {
    on<ClockStarted>(_onStarted);
    on<ClockPaused>(_onPaused);
    on<ClockResumed>(_onResumed);
    on<ClockReset>(_onReset);
    on<ClockTicked>(_onTicked);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(ClockStarted event, Emitter<ClockState> emit) {
    // if (state.clockType == ClockType.timer) {
    emit(ClockRunInProgress(event.clockType, event.duration));
    // }
    // print("test");
    _tickerSubscription?.cancel();
    _tickerSubscription = state.clockType == ClockType.stopwatch
        ? _ticker
            .tick()
            .listen((duration) => add(ClockTicked(duration: duration)))
        : _ticker
            .ntick(ticks: _duration)
            .listen((duration) => add(ClockTicked(duration: duration)));
  }

  void _onPaused(ClockPaused event, Emitter<ClockState> emit) {
    if (state is ClockRunInProgress) {
      _tickerSubscription?.pause();
      emit(ClockRunPause(state.clockType, state.duration));
    }
  }

  void _onResumed(ClockResumed resume, Emitter<ClockState> emit) {
    if (state is ClockRunPause) {
      _tickerSubscription?.resume();
      emit(ClockRunInProgress(state.clockType, state.duration));
    }
  }

  void _onReset(ClockReset event, Emitter<ClockState> emit) {
    _tickerSubscription?.cancel();
    emit(ClockInitial(state.clockType, state.duration));
  }

  void _onTicked(ClockTicked event, Emitter<ClockState> emit) {
    // print(event.duration);
    // print(state.duration);
    // print(state);
    emit(
      // event.duration <= 0 && state.clockType == ClockType.timer
      // ? TimerRunComplete()
      // :
      ClockRunInProgress(state.clockType, event.duration),
    );
  }
}
