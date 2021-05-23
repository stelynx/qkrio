import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'qkrio_dish.dart';

@immutable
class QkrioTimer extends Equatable {
  final QkrioDish dish;
  final DateTime started;

  bool get isOver =>
      DateTime.now().difference(started).inSeconds >= dish.duration.inSeconds;
  bool get isNotOver => !isOver;

  const QkrioTimer({
    required this.dish,
    required this.started,
  });

  factory QkrioTimer.fromLocalStorage(Map<String, dynamic> json) {
    return QkrioTimer(
      dish: QkrioDish.fromLocalStorage(json['dish']),
      started: DateTime.fromMillisecondsSinceEpoch(json['started']),
    );
  }

  Map<String, dynamic> toLocalStorage() {
    return <String, dynamic>{
      'dish': dish.toLocalStorage(),
      'started': started.millisecondsSinceEpoch,
    };
  }

  String presentableTime() {
    String present = '';

    final DateTime now = DateTime.now();
    final int secsPassed = now.difference(started).inSeconds;
    int secsToGo = dish.duration.inSeconds - secsPassed;

    final int hours = (secsToGo / 3600).floor();
    if (hours > 0) {
      present += hours < 10 ? '0$hours:' : '$hours:';
    }
    secsToGo -= hours * 3600;

    final int minutes = (secsToGo / 60).floor();
    present += minutes < 10 ? '0$minutes' : '$minutes';

    if (hours > 0) return present;

    secsToGo -= minutes * 60;
    present += secsToGo < 10 ? ':0$secsToGo' : ':$secsToGo';

    return present;
  }

  @override
  List<Object?> get props => [dish, started];
}
