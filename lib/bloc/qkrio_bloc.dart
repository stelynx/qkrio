import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../models/qkrio_dish.dart';
import '../models/qkrio_timer.dart';
import '../services/local_storage.dart';
import '../services/notification.dart';

part 'qkrio_event.dart';
part 'qkrio_state.dart';

class QkrioBloc extends Bloc<QkrioEvent, QkrioState> {
  final LocalStorageService _localStorageService;
  final NotificationService _notificationService;
  Timer? _uiRefreshTimer;

  QkrioBloc(
      {required LocalStorageService localStorageService,
      required NotificationService notificationService})
      : _localStorageService = localStorageService,
        _notificationService = notificationService,
        super(QkrioState.initial()) {
    add(const Initialize());
  }

  static void addTimer(BuildContext context, QkrioTimer timer) {
    BlocProvider.of<QkrioBloc>(context, listen: false).add(AddTimer(timer));
  }

  static void cancelTimer(BuildContext context, QkrioTimer timer) {
    BlocProvider.of<QkrioBloc>(context, listen: false).add(CancelTimer(timer));
  }

  static void addFavourite(BuildContext context, QkrioDish dish) {
    BlocProvider.of<QkrioBloc>(context, listen: false).add(AddFavourite(dish));
  }

  static void deleteFavourite(BuildContext context, QkrioDish dish) {
    BlocProvider.of<QkrioBloc>(context, listen: false)
        .add(DeleteFavourite(dish));
  }

  @override
  Stream<QkrioState> mapEventToState(
    QkrioEvent event,
  ) async* {
    if (event is Initialize) {
      final List<QkrioTimer> savedTimers =
          await _localStorageService.getTimers();
      final List<QkrioDish> savedFavourites =
          await _localStorageService.getFavourites();
      state.runningTimers.addAll(savedTimers);
      state.favouriteDishes.addAll(savedFavourites);
      await _notificationService.init(
          onSelectNotification: (String? payload) async =>
              add(NotificationSelected(payload)));
      yield state.copyWith();
      if (savedTimers.isNotEmpty) _startClock();
    } else if (event is AddTimer) {
      state.runningTimers.add(event.timer);
      await _localStorageService.saveTimers(state.runningTimers);
      await _notificationService.scheduleNotificationForTimer(event.timer);
      _startClock();
      yield state.copyWith();
    } else if (event is CancelTimer) {
      state.runningTimers.remove(event.timer);
      await _localStorageService.saveTimers(state.runningTimers);
      await _notificationService.cancelNotificationForTimer(event.timer);
      if (state.runningTimers.isEmpty) _stopClock();
      yield state.copyWith();
    } else if (event is AddFavourite) {
      state.favouriteDishes.add(event.dish);
      await _localStorageService.saveFavourites(state.favouriteDishes);
      yield state.copyWith();
    } else if (event is DeleteFavourite) {
      state.favouriteDishes.remove(event.dish);
      await _localStorageService.saveFavourites(state.favouriteDishes);
      yield state.copyWith();
    } else if (event is RefreshUi) {
      final List<QkrioTimer> remainingTimers = <QkrioTimer>[];

      bool shouldUpdateLocalStorage = false;
      for (QkrioTimer runningTimer in state.runningTimers) {
        if (runningTimer.isNotOver) {
          remainingTimers.add(runningTimer);
        } else {
          shouldUpdateLocalStorage = true;
        }
      }

      if (shouldUpdateLocalStorage) {
        await _localStorageService.saveTimers(remainingTimers);
      }

      yield state.copyWith(runningTimers: remainingTimers);
    } else if (event is NotificationSelected) {
      if (event.notificationPayload == null) return;

      try {
        final QkrioTimer timerToCancel = state.runningTimers.firstWhere(
            (QkrioTimer timer) =>
                timer.hashCode.toString() == event.notificationPayload);
        add(CancelTimer(timerToCancel));
      } on StateError {}
    }
  }

  void _startClock() {
    if (_uiRefreshTimer != null) return;

    _uiRefreshTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(const RefreshUi()),
    );
  }

  void _stopClock() {
    _uiRefreshTimer?.cancel();
    _uiRefreshTimer = null;
  }
}
