import 'package:flutter/cupertino.dart';

import '../models/qkrio_timer.dart';
import '../theme/style.dart';

class QkrioAddTimerDialog extends StatefulWidget {
  final void Function(QkrioTimer) onAdd;

  const QkrioAddTimerDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  _QkrioAddTimerDialogState createState() => _QkrioAddTimerDialogState();
}

class _QkrioAddTimerDialogState extends State<QkrioAddTimerDialog> {
  String _timerTitle = '';
  Duration _timerDuration = Duration.zero;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Add timer'),
      content: Column(
        children: <Widget>[
          const SizedBox(height: 10.0),
          CupertinoTextField(
            placeholder: 'I am cooking ...',
            onChanged: (String s) => setState(() => _timerTitle = s),
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
        ],
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        CupertinoDialogAction(
          child: const Text('Add'),
          isDefaultAction: true,
          onPressed: () {
            widget.onAdd(QkrioTimer(
              dishName: _timerTitle,
              started: DateTime.now(),
              duration: _timerDuration,
            ));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
