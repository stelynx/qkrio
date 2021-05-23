part of 'qkrio_bloc.dart';

@immutable
abstract class QkrioEvent {
  const QkrioEvent();
}

class Initialize extends QkrioEvent {
  const Initialize();
}

class AddTimer extends QkrioEvent {
  final QkrioTimer timer;

  const AddTimer(this.timer);
}

class CancelTimer extends QkrioEvent {
  final QkrioTimer timer;

  const CancelTimer(this.timer);
}

class RefreshUi extends QkrioEvent {
  const RefreshUi();
}

class NotificationSelected extends QkrioEvent {
  final String? notificationPayload;

  const NotificationSelected(this.notificationPayload);
}
