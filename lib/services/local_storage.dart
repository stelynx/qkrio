import 'package:localstorage/localstorage.dart';

import '../models/qkrio_timer.dart';

abstract class LocalStorageService {
  static const String _keyTimers = 'timers';

  static final LocalStorage _storage = LocalStorage('qkrio_storage');

  static Future<bool> saveTimers(List<QkrioTimer> timers) async {
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

  static Future<List<QkrioTimer>> getTimers() async {
    print('getting timers');
    if (!(await _storage.ready)) return <QkrioTimer>[];
    print('here');

    final timers = await _storage.getItem(_keyTimers);
    print(timers);

    return timers == null
        ? <QkrioTimer>[]
        : timers
            .map<QkrioTimer>((timer) => QkrioTimer.fromLocalStorage(timer))
            .toList();
  }
}
