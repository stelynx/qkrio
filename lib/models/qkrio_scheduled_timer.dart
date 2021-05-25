import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'qkrio_dish.dart';
import 'qkrio_timer.dart';

enum SchedulerNotifyBefore { min1, min5, min15, min30, min60 }

extension SchedulerNotifyBeforeToDuration on SchedulerNotifyBefore {
  Duration toDuration() {
    switch (this) {
      case SchedulerNotifyBefore.min1:
        return const Duration(minutes: 1);
      case SchedulerNotifyBefore.min5:
        return const Duration(minutes: 5);
      case SchedulerNotifyBefore.min15:
        return const Duration(minutes: 15);
      case SchedulerNotifyBefore.min30:
        return const Duration(minutes: 30);
      case SchedulerNotifyBefore.min60:
        return const Duration(minutes: 60);
    }
  }

  String presentable() {
    final int minutes = toDuration().inMinutes;
    return '$minutes minute${minutes == 1 ? '' : 's'}';
  }
}

enum SchedulerDateTimeType { start, end }

extension SchedulerDateTimeTypePresentable on SchedulerDateTimeType {
  String presentable() {
    switch (this) {
      case SchedulerDateTimeType.start:
        return "Start";
      case SchedulerDateTimeType.end:
        return "End";
    }
  }
}

@immutable
class QkrioScheduledTimer extends Equatable {
  final QkrioDish dish;
  final DateTime timerDateTime;
  final SchedulerDateTimeType dateTimeType;
  final SchedulerNotifyBefore? notifyBefore;
  final bool startAutomatically;

  const QkrioScheduledTimer({
    required this.dish,
    required this.timerDateTime,
    required this.dateTimeType,
    required this.notifyBefore,
    required this.startAutomatically,
  });

  DateTime get start {
    return dateTimeType == SchedulerDateTimeType.start
        ? timerDateTime
        : timerDateTime.subtract(dish.duration);
  }

  String get startAsString {
    final String hourString = '0${start.hour}';
    final String minuteString = '0${start.minute}';
    return hourString.substring(hourString.length - 2) +
        ':' +
        minuteString.substring(minuteString.length - 2);
  }

  bool get hasStarted => DateTime.now().isAfter(start);
  bool get hasNotStarted => !hasStarted;

  factory QkrioScheduledTimer.fromLocalStorage(Map<String, dynamic> json) {
    return QkrioScheduledTimer(
      dish: QkrioDish.fromLocalStorage(json['dish']),
      timerDateTime:
          DateTime.fromMillisecondsSinceEpoch(json['timer_datetime']),
      dateTimeType: SchedulerDateTimeType.values.firstWhere(
          (SchedulerDateTimeType sdtt) =>
              sdtt.toString() == json['datetime_type']),
      notifyBefore: json['notify_before'] == null
          ? null
          : SchedulerNotifyBefore.values.firstWhere(
              (SchedulerNotifyBefore snb) =>
                  snb.toString() == json['notify_before']),
      startAutomatically: json['start_automatically'],
    );
  }

  Map<String, dynamic> toLocalStorage() {
    return <String, dynamic>{
      'dish': dish.toLocalStorage(),
      'timer_datetime': timerDateTime.millisecondsSinceEpoch,
      'datetime_type': dateTimeType.toString(),
      'notify_before': notifyBefore.toString(),
      'start_automatically': startAutomatically,
    };
  }

  QkrioScheduledTimer copyWith({
    QkrioDish? dish,
    DateTime? timerDateTime,
    SchedulerDateTimeType? dateTimeType,
    SchedulerNotifyBefore? notifyBefore,
    bool overrideNotifyBefore = false,
    bool? startAutomatically,
  }) {
    return QkrioScheduledTimer(
      dish: dish ?? this.dish,
      timerDateTime: timerDateTime ?? this.timerDateTime,
      dateTimeType: dateTimeType ?? this.dateTimeType,
      notifyBefore:
          notifyBefore ?? (overrideNotifyBefore ? null : this.notifyBefore),
      startAutomatically: startAutomatically ?? this.startAutomatically,
    );
  }

  QkrioTimer toQkrioTimer() {
    return QkrioTimer(dish: dish, started: start);
  }

  @override
  List<Object?> get props => <Object?>[
        dish,
        timerDateTime,
        dateTimeType,
        notifyBefore,
        startAutomatically,
      ];
}
