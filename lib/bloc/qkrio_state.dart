part of 'qkrio_bloc.dart';

class QkrioState {
  final bool isLoaded;
  final List<QkrioTimer> runningTimers;
  final List<QkrioScheduledTimer> scheduledTimers;
  final List<QkrioDish> favouriteDishes;

  QkrioState({
    required this.isLoaded,
    required this.runningTimers,
    required this.scheduledTimers,
    required this.favouriteDishes,
  });

  QkrioState.initial()
      : isLoaded = false,
        runningTimers = <QkrioTimer>[],
        scheduledTimers = <QkrioScheduledTimer>[],
        favouriteDishes = <QkrioDish>[];

  QkrioState copyWith({
    List<QkrioTimer>? runningTimers,
    List<QkrioScheduledTimer>? scheduledTimers,
    List<QkrioDish>? favouriteDishes,
  }) =>
      QkrioState(
        isLoaded: true,
        runningTimers: runningTimers ?? this.runningTimers,
        scheduledTimers: scheduledTimers ?? this.scheduledTimers,
        favouriteDishes: favouriteDishes ?? this.favouriteDishes,
      );
}
