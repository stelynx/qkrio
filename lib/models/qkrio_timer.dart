import 'package:flutter/foundation.dart';

@immutable
class QkrioTimer {
  final String dishName;
  final DateTime started;
  final Duration duration;

  bool get isOver =>
      DateTime.now().difference(started).inSeconds == duration.inSeconds;
  bool get isNotOver => !isOver;

  const QkrioTimer({
    required this.dishName,
    required this.started,
    required this.duration,
  });

  factory QkrioTimer.fromLocalStorage(Map<String, dynamic> json) {
    return QkrioTimer(
      dishName: json['dish_name'],
      started: DateTime.fromMillisecondsSinceEpoch(json['started']),
      duration: Duration(seconds: json['duration']),
    );
  }

  Map<String, dynamic> toLocalStorage() {
    return <String, dynamic>{
      'dish_name': dishName,
      'started': started.millisecondsSinceEpoch,
      'duration': duration.inSeconds,
    };
  }

  String presentableTime() {
    String present = '';

    final DateTime now = DateTime.now();
    final int secsPassed = now.difference(started).inSeconds;
    int secsToGo = duration.inSeconds - secsPassed;

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
  bool operator ==(Object other) {
    return other is QkrioTimer &&
        other.dishName == dishName &&
        other.started == started &&
        other.duration == duration;
  }

  @override
  int get hashCode => dishName.hashCode;
}
