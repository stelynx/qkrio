import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class QkrioDish extends Equatable {
  final String dishName;
  final Duration duration;
  final String? note;
  final bool isFavourite;

  const QkrioDish({
    required this.dishName,
    required this.duration,
    this.note,
    this.isFavourite = false,
  });

  factory QkrioDish.fromLocalStorage(Map<String, dynamic> json) {
    return QkrioDish(
      dishName: json['dish_name'],
      duration: Duration(seconds: json['duration']),
      note: json['note'],
      isFavourite: json['is_favourite'],
    );
  }

  Map<String, dynamic> toLocalStorage() {
    return <String, dynamic>{
      'dish_name': dishName,
      'duration': duration.inSeconds,
      'note': note,
      'is_favourite': isFavourite,
    };
  }

  String presentableDuration() {
    String s = '';

    final int hrs = duration.inHours;
    if (hrs > 0) s += '$hrs h ';

    final int mins = (duration - Duration(hours: hrs)).inMinutes;
    if (mins > 0) s += '$mins min ';

    final int secs = (duration - Duration(hours: hrs, minutes: mins)).inSeconds;
    if (secs > 0) s += '$secs sec ';

    return s.substring(0, s.length - 1);
  }

  @override
  List<Object?> get props => [dishName, note, duration, isFavourite];
}
