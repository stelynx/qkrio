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
  final bool showNotification;

  const AddTimer(this.timer, {required this.showNotification});
}

class CancelTimer extends QkrioEvent {
  final QkrioTimer timer;

  const CancelTimer(this.timer);
}

class AddFavourite extends QkrioEvent {
  final QkrioDish dish;

  const AddFavourite(this.dish);
}

class DeleteFavourite extends QkrioEvent {
  final QkrioDish dish;

  const DeleteFavourite(this.dish);
}

class RefreshUi extends QkrioEvent {
  const RefreshUi();
}

class NotificationSelected extends QkrioEvent {
  final String? notificationPayload;

  const NotificationSelected(this.notificationPayload);
}
