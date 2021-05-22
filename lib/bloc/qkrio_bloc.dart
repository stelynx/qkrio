import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../models/qkrio_timer.dart';
import '../services/local_storage.dart';

part 'qkrio_event.dart';
part 'qkrio_state.dart';

class QkrioBloc extends Bloc<QkrioEvent, QkrioState> {
  Timer? _uiRefreshTimer;

  QkrioBloc() : super(QkrioState.initial()) {
    add(const Initialize());
  }

  static void addTimer(BuildContext context, QkrioTimer timer) {
    BlocProvider.of<QkrioBloc>(context, listen: false).add(AddTimer(timer));
  }

  static void cancelTimer(BuildContext context, QkrioTimer timer) {
    BlocProvider.of<QkrioBloc>(context, listen: false).add(CancelTimer(timer));
  }

  @override
  Stream<QkrioState> mapEventToState(
    QkrioEvent event,
  ) async* {
    if (event is Initialize) {
      final List<QkrioTimer> savedTimers =
          await LocalStorageService.getTimers();
      state.runningTimers.addAll(savedTimers);
      yield state.copyWith();
      if (savedTimers.isNotEmpty) _startClock();
    } else if (event is AddTimer) {
      state.runningTimers.add(event.timer);
      await LocalStorageService.saveTimers(state.runningTimers);
      _startClock();
      yield state.copyWith();
    } else if (event is CancelTimer) {
      state.runningTimers.remove(event.timer);
      await LocalStorageService.saveTimers(state.runningTimers);
      if (state.runningTimers.isEmpty) _stopClock();
      yield state.copyWith();
    } else if (event is RefreshUi) {
      final List<QkrioTimer> remainingTimers = <QkrioTimer>[];

      bool shouldUpdateLocalStorage = false;
      for (QkrioTimer runningTimer in state.runningTimers) {
        if (runningTimer.isNotOver) {
          remainingTimers.add(runningTimer);
        } else {
          shouldUpdateLocalStorage = true;
          // TODO push notification and sound
        }
      }

      if (shouldUpdateLocalStorage) {
        await LocalStorageService.saveTimers(remainingTimers);
      }

      yield state.copyWith(runningTimers: remainingTimers);
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
