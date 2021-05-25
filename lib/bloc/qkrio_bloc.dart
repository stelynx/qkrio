import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../models/qkrio_dish.dart';
import '../models/qkrio_scheduled_timer.dart';
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

  static void addTimer(
    BuildContext context,
    QkrioTimer timer, {
    bool startedFromFavourites = false,
  }) {
    BlocProvider.of<QkrioBloc>(context, listen: false).add(AddTimer(
      timer,
      startedFromFavourites: startedFromFavourites,
    ));
  }

  static void cancelTimer(BuildContext context, QkrioTimer timer) {
    BlocProvider.of<QkrioBloc>(context, listen: false).add(CancelTimer(timer));
  }

  static void toggleFavouriteOnTimer(BuildContext context, QkrioTimer timer) {
    BlocProvider.of<QkrioBloc>(context, listen: false)
        .add(ToggleFavouriteOnTimer(timer));
  }

  static void addScheduledTimer(
    BuildContext context,
    QkrioScheduledTimer scheduledTimer,
  ) {
    BlocProvider.of<QkrioBloc>(context, listen: false)
        .add(AddScheduledTimer(scheduledTimer));
  }

  static void updateScheduledTimer(
    BuildContext context,
    QkrioScheduledTimer oldScheduledTimer,
    QkrioScheduledTimer newScheduledTimer,
  ) {
    BlocProvider.of<QkrioBloc>(context, listen: false)
        .add(UpdateScheduledTimer(oldScheduledTimer, newScheduledTimer));
  }

  static void cancelScheduledTimer(
    BuildContext context,
    QkrioScheduledTimer scheduledTimer,
  ) {
    BlocProvider.of<QkrioBloc>(context, listen: false)
        .add(CancelScheduledTimer(scheduledTimer));
  }

  static void cancelAutostartOnScheduledTimer(
    BuildContext context,
    QkrioScheduledTimer scheduledTimer,
  ) {
    BlocProvider.of<QkrioBloc>(context, listen: false)
        .add(CancelAutostartOnScheduledTimer(scheduledTimer));
  }

  static void cancelNotifyBeforeOnScheduledTimer(
    BuildContext context,
    QkrioScheduledTimer scheduledTimer,
  ) {
    BlocProvider.of<QkrioBloc>(context, listen: false)
        .add(CancelNotifyBeforeOnScheduledTimer(scheduledTimer));
  }

  static void addFavourite(BuildContext context, QkrioDish dish) {
    BlocProvider.of<QkrioBloc>(context, listen: false).add(AddFavourite(dish));
  }

  static void updateFavourite(
    BuildContext context,
    QkrioDish oldDish,
    QkrioDish newDish,
  ) {
    BlocProvider.of<QkrioBloc>(context, listen: false)
        .add(UpdateFavourite(oldDish, newDish));
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
      state.runningTimers
          .addAll(savedTimers.where((QkrioTimer timer) => timer.isNotOver));

      final List<QkrioScheduledTimer> savedScheduled =
          await _localStorageService.getScheduledTimers();
      state.scheduledTimers.addAll(savedScheduled
          .where((QkrioScheduledTimer timer) => timer.hasNotStarted));
      for (QkrioScheduledTimer scheduledTimer in savedScheduled.where(
          (QkrioScheduledTimer scheduledTimer) =>
              scheduledTimer.hasStarted && scheduledTimer.startAutomatically)) {
        state.runningTimers.add(scheduledTimer.toQkrioTimer());
      }

      final List<QkrioDish> savedFavourites =
          await _localStorageService.getFavourites();
      state.favouriteDishes.addAll(savedFavourites);

      await _notificationService.init(
          onSelectNotification: (String? payload) async =>
              add(NotificationSelected(payload)));

      yield state.copyWith();
      if (state.runningTimers.isNotEmpty || state.scheduledTimers.isNotEmpty) {
        _startClock();
      }
    } else if (event is AddTimer) {
      state.runningTimers.add(event.timer);
      await _localStorageService.saveTimers(state.runningTimers);
      await _notificationService.scheduleNotificationForTimer(event.timer);
      _startClock();
      if (event.startedFromFavourites) {
        await _notificationService.showNotificationForTimer(event.timer);
      } else {
        if (event.timer.dish.isFavourite) {
          add(AddFavourite(event.timer.dish));
        }
      }
      yield state.copyWith();
    } else if (event is CancelTimer) {
      state.runningTimers.remove(event.timer);
      await _localStorageService.saveTimers(state.runningTimers);
      await _notificationService.cancelNotificationForTimer(event.timer);
      if (state.runningTimers.isEmpty) _stopClock();
      yield state.copyWith();
    } else if (event is ToggleFavouriteOnTimer) {
      final QkrioDish newDish = QkrioDish(
        dishName: event.timer.dish.dishName,
        duration: event.timer.dish.duration,
        note: event.timer.dish.note,
        isFavourite: !event.timer.dish.isFavourite,
      );
      add(event.timer.dish.isFavourite
          ? DeleteFavourite(event.timer.dish)
          : AddFavourite(newDish));

      state.runningTimers[state.runningTimers.indexOf(event.timer)] =
          QkrioTimer(
        dish: newDish,
        started: event.timer.started,
      );
      yield state.copyWith();
    } else if (event is AddScheduledTimer) {
      state.scheduledTimers.add(event.scheduledTimer);
      await _localStorageService.saveScheduledTimers(state.scheduledTimers);
      if (event.scheduledTimer.notifyBefore != null) {
        await _notificationService
            .scheduleNotificationForScheduledTimer(event.scheduledTimer);
      }
      if (event.scheduledTimer.startAutomatically) {
        _startClock();
        await _notificationService
            .scheduleNotificationForTimer(event.scheduledTimer.toQkrioTimer());
      }
      yield state.copyWith();
    } else if (event is UpdateScheduledTimer) {
      if (event.oldScheduledTimer.notifyBefore != null) {
        await _notificationService
            .cancelNotificationForScheduledTimer(event.oldScheduledTimer);
      }
      if (event.oldScheduledTimer.startAutomatically) {
        await _notificationService
            .cancelNotificationForTimer(event.oldScheduledTimer.toQkrioTimer());
      }
      if (event.newScheduledTimer.notifyBefore != null) {
        await _notificationService
            .scheduleNotificationForScheduledTimer(event.newScheduledTimer);
      }
      if (event.newScheduledTimer.startAutomatically) {
        await _notificationService.scheduleNotificationForTimer(
            event.newScheduledTimer.toQkrioTimer());
      }
      state.scheduledTimers[state.scheduledTimers
          .indexOf(event.oldScheduledTimer)] = event.newScheduledTimer;
      await _localStorageService.saveScheduledTimers(state.scheduledTimers);
      yield state.copyWith();
    } else if (event is CancelScheduledTimer) {
      state.scheduledTimers.remove(event.scheduledTimer);
      await _localStorageService.saveScheduledTimers(state.scheduledTimers);
      if (event.scheduledTimer.notifyBefore != null) {
        await _notificationService
            .cancelNotificationForScheduledTimer(event.scheduledTimer);
      }
      if (event.scheduledTimer.startAutomatically) {
        await _notificationService
            .cancelNotificationForTimer(event.scheduledTimer.toQkrioTimer());
      }
      yield state.copyWith();
    } else if (event is CancelAutostartOnScheduledTimer) {
      await _notificationService
          .cancelNotificationForTimer(event.scheduledTimer.toQkrioTimer());

      state.scheduledTimers[
              state.scheduledTimers.indexOf(event.scheduledTimer)] =
          event.scheduledTimer.copyWith(startAutomatically: false);
      await _localStorageService.saveScheduledTimers(state.scheduledTimers);
      yield state.copyWith();
    } else if (event is CancelNotifyBeforeOnScheduledTimer) {
      await _notificationService
          .cancelNotificationForScheduledTimer(event.scheduledTimer);

      state.scheduledTimers[state.scheduledTimers
          .indexOf(event.scheduledTimer)] = event.scheduledTimer.copyWith(
        notifyBefore: null,
        overrideNotifyBefore: true,
      );
      await _localStorageService.saveScheduledTimers(state.scheduledTimers);
      yield state.copyWith();
    } else if (event is AddFavourite) {
      state.favouriteDishes.add(event.dish);
      await _localStorageService.saveFavourites(state.favouriteDishes);
      yield state.copyWith();
    } else if (event is UpdateFavourite) {
      state.favouriteDishes[state.favouriteDishes.indexOf(event.oldDish)] =
          event.newDish;
      await _localStorageService.saveFavourites(state.favouriteDishes);
      yield state.copyWith();
    } else if (event is DeleteFavourite) {
      state.favouriteDishes.remove(event.dish);
      await _localStorageService.saveFavourites(state.favouriteDishes);
      yield state.copyWith();
    } else if (event is RefreshUi) {
      // Already running timers
      final List<QkrioTimer> remainingTimers = <QkrioTimer>[];
      for (QkrioTimer runningTimer in state.runningTimers) {
        if (runningTimer.isNotOver) {
          remainingTimers.add(runningTimer);
        }
      }

      // Scheduled timers
      final List<QkrioScheduledTimer> remainingScheduledTimers =
          <QkrioScheduledTimer>[];
      for (QkrioScheduledTimer scheduledTimer in state.scheduledTimers) {
        if (DateTime.now().millisecondsSinceEpoch ~/ 1000 ==
            scheduledTimer.start.millisecondsSinceEpoch ~/ 1000) {
          if (scheduledTimer.startAutomatically) {
            remainingTimers.add(scheduledTimer.toQkrioTimer());
          }
        } else {
          remainingScheduledTimers.add(scheduledTimer);
        }
      }

      await _localStorageService.saveTimers(remainingTimers);
      await _localStorageService.saveScheduledTimers(remainingScheduledTimers);
      yield state.copyWith(
        runningTimers: remainingTimers,
        scheduledTimers: remainingScheduledTimers,
      );
    } else if (event is NotificationSelected) {
      if (event.notificationPayload == null) return;

      if (event.notificationPayload![0] == 'T') {
        try {
          final QkrioTimer timerToCancel = state.runningTimers.firstWhere(
              (QkrioTimer timer) =>
                  timer.hashCode.toString() ==
                  event.notificationPayload!.substring(1));
          add(CancelTimer(timerToCancel));
        } on StateError {}
      } else if (event.notificationPayload![0] == 'S') {}
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
    if (state.runningTimers.isNotEmpty || state.scheduledTimers.isNotEmpty) {
      return;
    }
    _uiRefreshTimer?.cancel();
    _uiRefreshTimer = null;
  }
}
