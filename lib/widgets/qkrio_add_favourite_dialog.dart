import 'package:flutter/cupertino.dart';

import '../models/qkrio_dish.dart';
import '../theme/style.dart';
import 'util/qkrio_dialog_action.dart';

class QkrioAddFavouriteDialog extends StatefulWidget {
  final void Function(QkrioDish) onAdd;

  const QkrioAddFavouriteDialog({Key? key, required this.onAdd})
      : super(key: key);

  @override
  _QkrioAddFavouriteDialogState createState() =>
      _QkrioAddFavouriteDialogState();
}

class _QkrioAddFavouriteDialogState extends State<QkrioAddFavouriteDialog> {
  String _dishName = '';
  String _note = '';
  Duration _timerDuration = Duration.zero;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Add New Favourite'),
      content: Column(
        children: <Widget>[
          const SizedBox(height: 10.0),
          CupertinoTextField(
            placeholder: 'Dish name',
            onChanged: (String s) => setState(() => _dishName = s),
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
          text: 'Add',
          isDefaultAction: true,
          enabled: _timerDuration.inSeconds > 10 && _dishName.trim().isNotEmpty,
          onPressed: () {
            final String noteTrimmed = _note.trim();
            widget.onAdd(QkrioDish(
              dishName: _dishName,
              duration: _timerDuration,
              note: noteTrimmed.isNotEmpty ? noteTrimmed : null,
              isFavourite: true,
            ));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
