import 'package:flutter/cupertino.dart';

import '../models/qkrio_dish.dart';
import '../theme/style.dart';

class QkrioAddFavouriteDialog extends StatefulWidget {
  final void Function(QkrioDish) onAdd;

  const QkrioAddFavouriteDialog({Key? key, required this.onAdd})
      : super(key: key);

  @override
  _QkrioAddFavouriteDialogState createState() =>
      _QkrioAddFavouriteDialogState();
}

class _QkrioAddFavouriteDialogState extends State<QkrioAddFavouriteDialog> {
  String _timerTitle = '';
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
            widget.onAdd(QkrioDish(
              dishName: _timerTitle,
              duration: _timerDuration,
              isFavourite: true,
            ));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
