import 'package:flutter/cupertino.dart';

import '../bloc/qkrio_bloc.dart';
import '../models/qkrio_dish.dart';
import 'qkrio_add_favourite_dialog.dart';

class QkrioFavouriteTile extends StatefulWidget {
  final QkrioDish dish;
  final VoidCallback onTimerStart;
  final VoidCallback onDelete;

  const QkrioFavouriteTile({
    Key? key,
    required this.dish,
    required this.onTimerStart,
    required this.onDelete,
  }) : super(key: key);

  @override
  _QkrioFavouriteTileState createState() => _QkrioFavouriteTileState();
}

class _QkrioFavouriteTileState extends State<QkrioFavouriteTile> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _isSelected ? CupertinoColors.lightBackgroundGray : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 3 / 4,
                  ),
                  child: Text(
                    widget.dish.dishName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                              fontSize: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle
                                      .fontSize! *
                                  1.5,
                              fontWeight: FontWeight.w200,
                            ),
                  ),
                ),
                Text(
                  widget.dish.presentableDuration(),
                  style: CupertinoTheme.of(context).textTheme.textStyle,
                ),
                const SizedBox(height: 3.0),
              ],
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(
                CupertinoIcons.list_bullet,
              ),
              onPressed: () async {
                setState(() => _isSelected = true);
                await _openTimerOptions();
                setState(() => _isSelected = false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openTimerOptions() {
    return showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoActionSheet(
            title: Text(widget.dish.dishName),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                onPressed: () {
                  widget.onTimerStart();
                  Navigator.of(context).pop();
                },
                child: const Text('Start timer'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  showCupertinoDialog(
                      context: context,
                      builder: (_) {
                        return QkrioAddFavouriteDialog(
                          initialDish: widget.dish,
                          onAdd: (QkrioDish dish) => QkrioBloc.updateFavourite(
                              context, widget.dish, dish),
                        );
                      });
                },
                child: const Text('Edit'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  widget.onDelete();
                  Navigator.of(context).pop();
                },
                child: const Text('Delete'),
                isDestructiveAction: true,
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          );
        });
  }
}
