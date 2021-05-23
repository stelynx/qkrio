part of 'qkrio_bloc.dart';

class QkrioState {
  final bool isLoaded;
  final List<QkrioTimer> runningTimers;
  final List<QkrioDish> favouriteDishes;

  QkrioState({
    required this.isLoaded,
    required this.runningTimers,
    required this.favouriteDishes,
  });

  QkrioState.initial()
      : isLoaded = false,
        runningTimers = <QkrioTimer>[],
        favouriteDishes = <QkrioDish>[];

  QkrioState copyWith({
    List<QkrioTimer>? runningTimers,
    List<QkrioDish>? favouriteDishes,
  }) =>
      QkrioState(
        isLoaded: true,
        runningTimers: runningTimers ?? this.runningTimers,
        favouriteDishes: favouriteDishes ?? this.favouriteDishes,
      );
}
