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
  final bool startedFromFavourites;

  const AddTimer(this.timer, {required this.startedFromFavourites});
}

class CancelTimer extends QkrioEvent {
  final QkrioTimer timer;

  const CancelTimer(this.timer);
}

class ToggleFavouriteOnTimer extends QkrioEvent {
  final QkrioTimer timer;

  const ToggleFavouriteOnTimer(this.timer);
}

class AddScheduledTimer extends QkrioEvent {
  final QkrioScheduledTimer scheduledTimer;

  const AddScheduledTimer(this.scheduledTimer);
}

class UpdateScheduledTimer extends QkrioEvent {
  final QkrioScheduledTimer oldScheduledTimer;
  final QkrioScheduledTimer newScheduledTimer;

  const UpdateScheduledTimer(this.oldScheduledTimer, this.newScheduledTimer);
}

class CancelScheduledTimer extends QkrioEvent {
  final QkrioScheduledTimer scheduledTimer;

  const CancelScheduledTimer(this.scheduledTimer);
}

class CancelAutostartOnScheduledTimer extends QkrioEvent {
  final QkrioScheduledTimer scheduledTimer;

  const CancelAutostartOnScheduledTimer(this.scheduledTimer);
}

class CancelNotifyBeforeOnScheduledTimer extends QkrioEvent {
  final QkrioScheduledTimer scheduledTimer;

  const CancelNotifyBeforeOnScheduledTimer(this.scheduledTimer);
}

class AddFavourite extends QkrioEvent {
  final QkrioDish dish;

  const AddFavourite(this.dish);
}

class UpdateFavourite extends QkrioEvent {
  final QkrioDish oldDish;
  final QkrioDish newDish;

  const UpdateFavourite(this.oldDish, this.newDish);
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
