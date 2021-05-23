import 'package:localstorage/localstorage.dart';

import '../models/qkrio_timer.dart';

class LocalStorageService {
  static const String _keyTimers = 'timers';

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
}
