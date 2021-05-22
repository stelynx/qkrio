part of 'qkrio_bloc.dart';

class QkrioState {
  final bool isLoaded;
  final List<QkrioTimer> runningTimers;

  QkrioState({
    required this.isLoaded,
    required this.runningTimers,
  });

  QkrioState.initial()
      : isLoaded = false,
        runningTimers = <QkrioTimer>[];

  QkrioState copyWith({
    List<QkrioTimer>? runningTimers,
  }) =>
      QkrioState(
        isLoaded: true,
        runningTimers: runningTimers ?? this.runningTimers,
      );
}
