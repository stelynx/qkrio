import 'package:localstorage/localstorage.dart';

import '../models/qkrio_dish.dart';
import '../models/qkrio_scheduled_timer.dart';
import '../models/qkrio_timer.dart';

class LocalStorageService {
  static const String _keyTimers = 'timers';
  static const String _keyScheduledTimers = 'scheduled_timers';
  static const String _keyFavourites = 'favourites';

  static final LocalStorageService _instance = LocalStorageService._();
  final LocalStorage _storage;

  factory LocalStorageService() => _instance;

  LocalStorageService._() : _storage = LocalStorage('qkrio_storage');

  Future<bool> saveTimers(List<QkrioTimer> timers) async {
    if (!(await _storage.ready)) return false;

    await _storage.setItem(
      _keyTimers,
      timers
          .map<Map<String, dynamic>>(
              (QkrioTimer timer) => timer.toLocalStorage())
          .toList(),
    );

    return true;
  }

  Future<List<QkrioTimer>> getTimers() async {
    if (!(await _storage.ready)) return <QkrioTimer>[];

    final timers = await _storage.getItem(_keyTimers);

    return timers == null
        ? <QkrioTimer>[]
        : timers
            .map<QkrioTimer>((timer) => QkrioTimer.fromLocalStorage(timer))
            .toList();
  }

  Future<bool> saveScheduledTimers(List<QkrioScheduledTimer> timers) async {
    if (!(await _storage.ready)) return false;

    await _storage.setItem(
        _keyScheduledTimers,
        timers
            .map<Map<String, dynamic>>(
                (QkrioScheduledTimer timer) => timer.toLocalStorage())
            .toList());

    return true;
  }

  Future<List<QkrioScheduledTimer>> getScheduledTimers() async {
    if (!(await _storage.ready)) return <QkrioScheduledTimer>[];

    final timers = await _storage.getItem(_keyScheduledTimers);

    return timers == null
        ? <QkrioScheduledTimer>[]
        : timers
            .map<QkrioScheduledTimer>(
                (timer) => QkrioScheduledTimer.fromLocalStorage(timer))
            .toList();
  }

  Future<bool> saveFavourites(List<QkrioDish> favourites) async {
    if (!(await _storage.ready)) return false;

    await _storage.setItem(
      _keyFavourites,
      favourites
          .map<Map<String, dynamic>>((QkrioDish dish) => dish.toLocalStorage())
          .toList(),
    );

    return true;
  }

  Future<List<QkrioDish>> getFavourites() async {
    if (!(await _storage.ready)) return <QkrioDish>[];

    final favourites = await _storage.getItem(_keyFavourites);

    return favourites == null
        ? <QkrioDish>[]
        : favourites
            .map<QkrioDish>(
                (favourite) => QkrioDish.fromLocalStorage(favourite))
            .toList();
  }
}
