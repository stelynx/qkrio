import 'package:flutter/cupertino.dart';

import '../models/qkrio_dish.dart';
import '../models/qkrio_timer.dart';
import '../theme/style.dart';
import 'util/qkrio_dialog_action.dart';

class QkrioAddTimerDialog extends StatefulWidget {
  final void Function(QkrioTimer) onAdd;

  const QkrioAddTimerDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  _QkrioAddTimerDialogState createState() => _QkrioAddTimerDialogState();
}

class _QkrioAddTimerDialogState extends State<QkrioAddTimerDialog> {
  String _timerTitle = '';
  String _note = '';
  Duration _timerDuration = Duration.zero;
  bool _isFavourite = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Add Timer'),
      content: Column(
        children: <Widget>[
          const SizedBox(height: 10.0),
          CupertinoTextField(
            placeholder: 'I am cooking ...',
            onChanged: (String s) => setState(() => _timerTitle = s),
          ),
          const SizedBox(height: 10.0),
          CupertinoTextField(
            placeholder: 'Note (Optional)',
            onChanged: (String s) => setState(() => _note = s),
          ),
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
            child: CupertinoTimerPicker(
              initialTimerDuration: _timerDuration,
              mode: CupertinoTimerPickerMode.hms,
              onTimerDurationChanged: (Duration d) {
                setState(() => _timerDuration = d);
              },
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Save to favourites'),
              CupertinoSwitch(
                value: _isFavourite,
                onChanged: (bool v) => setState(() => _isFavourite = v),
                activeColor: CupertinoTheme.of(context).primaryColor,
              ),
            ],
          ),
        ],
      ),
      actions: <QkrioDialogAction>[
        QkrioDialogAction(
          text: 'Cancel',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        QkrioDialogAction(
          text: 'Start',
          isDefaultAction: true,
          enabled:
              _timerDuration.inSeconds > 10 && _timerTitle.trim().isNotEmpty,
          onPressed: () {
            final String noteTrimmed = _note.trim();
            widget.onAdd(QkrioTimer(
              dish: QkrioDish(
                dishName: _timerTitle,
                duration: _timerDuration,
                note: noteTrimmed.isNotEmpty ? noteTrimmed : null,
                isFavourite: _isFavourite,
              ),
              started: DateTime.now(),
            ));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
