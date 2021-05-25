import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../models/qkrio_dish.dart';
import '../models/qkrio_scheduled_timer.dart';
import '../theme/style.dart';
import 'util/qkrio_dialog_action.dart';
import 'util/separator.dart';

class QkrioAddScheduledDialog extends StatefulWidget {
  final QkrioScheduledTimer? initialScheduledTimer;
  final void Function(QkrioScheduledTimer) onAdd;

  const QkrioAddScheduledDialog({
    Key? key,
    this.initialScheduledTimer,
    required this.onAdd,
  }) : super(key: key);

  @override
  _QkrioAddScheduledDialogState createState() =>
      _QkrioAddScheduledDialogState();
}

class _QkrioAddScheduledDialogState extends State<QkrioAddScheduledDialog> {
  String _dishName = '';
  String _dishNote = '';
  Duration _duration = Duration.zero;
  bool _isFavourite = false;
  DateTime _timerDateTime = DateTime.now();
  SchedulerDateTimeType _dateTimeType = SchedulerDateTimeType.start;
  SchedulerNotifyBefore? _notifyBefore;
  bool _startAutomatically = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialScheduledTimer != null) {
      _dishName = widget.initialScheduledTimer!.dish.dishName;
      _dishNote = widget.initialScheduledTimer!.dish.note ?? '';
      _duration = widget.initialScheduledTimer!.dish.duration;
      _isFavourite = widget.initialScheduledTimer!.dish.isFavourite;
      _timerDateTime = widget.initialScheduledTimer!.timerDateTime;
      _dateTimeType = widget.initialScheduledTimer!.dateTimeType;
      _notifyBefore = widget.initialScheduledTimer!.notifyBefore;
      _startAutomatically = widget.initialScheduledTimer!.startAutomatically;
    }
  }

  bool get _isValid =>
      _dishName.trim().isNotEmpty &&
      _duration.inSeconds > 10 &&
      _timerDateTime
              .subtract(_notifyBefore?.toDuration() ?? Duration.zero)
              .subtract(_dateTimeType == SchedulerDateTimeType.start
                  ? Duration.zero
                  : _duration)
              .difference(DateTime.now())
              .inMinutes >
          1;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(widget.initialScheduledTimer == null
          ? 'Add Scheduled Timer'
          : 'Edit Scheduled Timer'),
      content: Container(
        constraints: BoxConstraints(
          maxHeight: max(
            MediaQuery.of(context).size.height - 300,
            MediaQuery.of(context).size.height * 0.6,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 10.0),
              CupertinoTextField(
                placeholder: 'Dish name',
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                    text: _dishName,
                    selection: TextSelection.fromPosition(
                      TextPosition(offset: _dishName.length),
                    ),
                  ),
                ),
                onChanged: (String s) => setState(() => _dishName = s),
              ),
              const SizedBox(height: 10.0),
              CupertinoTextField(
                placeholder: 'Note (Optional)',
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                    text: _dishNote,
                    selection: TextSelection.fromPosition(
                      TextPosition(offset: _dishNote.length),
                    ),
                  ),
                ),
                onChanged: (String s) => setState(() => _dishNote = s),
              ),
              const SizedBox(height: 10.0),
              const Text('Cooking duration'),
              Container(
                height: 100.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: CupertinoColors.darkBackgroundGray,
                    width: 0.5,
                  ),
                  borderRadius: QkrioStyle.borderRadius,
                ),
                child: CupertinoTimerPicker(
                  initialTimerDuration: _duration,
                  mode: CupertinoTimerPickerMode.hms,
                  onTimerDurationChanged: (Duration d) {
                    setState(() => _duration = d);
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    constraints: const BoxConstraints(maxWidth: 150),
                    child: const Text('Save to favourites'),
                  ),
                  CupertinoSwitch(
                    value: _isFavourite,
                    onChanged: (bool v) => setState(() => _isFavourite = v),
                    activeColor: CupertinoTheme.of(context).primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              const Separator(),
              const SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: CupertinoSegmentedControl<SchedulerDateTimeType>(
                      groupValue: _dateTimeType,
                      onValueChanged: (SchedulerDateTimeType sdtt) =>
                          setState(() => _dateTimeType = sdtt),
                      children: SchedulerDateTimeType.values.asMap().map(
                            (_, SchedulerDateTimeType sdtt) =>
                                MapEntry<SchedulerDateTimeType, Widget>(
                              sdtt,
                              Text(sdtt.presentable()),
                            ),
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Text(_dateTimeType == SchedulerDateTimeType.start
                  ? 'I need to start cooking at'
                  : 'I want my dish ready at'),
              Container(
                height: 100.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: CupertinoColors.darkBackgroundGray,
                    width: 0.5,
                  ),
                  borderRadius: QkrioStyle.borderRadius,
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: _timerDateTime,
                  onDateTimeChanged: (DateTime dt) =>
                      setState(() => _timerDateTime = dt),
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    constraints: const BoxConstraints(maxWidth: 150),
                    child: const Text(
                      'Start timer automatically',
                      textAlign: TextAlign.start,
                    ),
                  ),
                  CupertinoSwitch(
                    value: _startAutomatically,
                    activeColor: CupertinoTheme.of(context).primaryColor,
                    onChanged: (bool v) =>
                        setState(() => _startAutomatically = v),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              const Separator(),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    constraints: const BoxConstraints(maxWidth: 150),
                    child: const Text('Notify me before start'),
                  ),
                  CupertinoSwitch(
                    value: _notifyBefore != null,
                    activeColor: CupertinoTheme.of(context).primaryColor,
                    onChanged: (bool v) => setState(() =>
                        _notifyBefore = v ? SchedulerNotifyBefore.min5 : null),
                  ),
                ],
              ),
              if (_notifyBefore != null) ...[
                const SizedBox(height: 10.0),
                Container(
                  height: 100.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: CupertinoColors.darkBackgroundGray,
                      width: 0.5,
                    ),
                    borderRadius: QkrioStyle.borderRadius,
                  ),
                  child: CupertinoPicker(
                    itemExtent: 27.5,
                    scrollController: FixedExtentScrollController(
                      initialItem:
                          SchedulerNotifyBefore.values.indexOf(_notifyBefore!),
                    ),
                    onSelectedItemChanged: (int i) {
                      setState(() {
                        _notifyBefore = SchedulerNotifyBefore.values[i];
                      });
                    },
                    children: SchedulerNotifyBefore.values
                        .map<Widget>((SchedulerNotifyBefore snb) =>
                            Text(snb.presentable()))
                        .toList(),
                  ),
                ),
              ],
              if (!_isValid) ...[
                const SizedBox(height: 10.0),
                const Separator(),
                const SizedBox(height: 10.0),
                const Text(
                  'Dish name must not be empty, timer duration must be greater than 10 seconds, and start (or reminder if set) has to be at least 10 minutes from now.',
                  style: TextStyle(color: CupertinoColors.destructiveRed),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: <QkrioDialogAction>[
        QkrioDialogAction(
          text: 'Cancel',
          onPressed: () => Navigator.of(context).pop(),
        ),
        QkrioDialogAction(
          text: widget.initialScheduledTimer == null ? 'Add' : 'Save',
          onPressed: () {
            Navigator.of(context).pop();
            widget.onAdd(QkrioScheduledTimer(
              dish: QkrioDish(
                dishName: _dishName,
                duration: _duration,
                note: _dishNote,
                isFavourite: _isFavourite,
              ),
              timerDateTime: _timerDateTime,
              dateTimeType: _dateTimeType,
              notifyBefore: _notifyBefore,
              startAutomatically: _startAutomatically,
            ));
          },
          isDefaultAction: true,
          enabled: _isValid,
        ),
      ],
    );
  }
}
