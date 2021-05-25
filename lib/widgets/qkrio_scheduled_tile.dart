import 'package:flutter/cupertino.dart';

import '../bloc/qkrio_bloc.dart';
import '../models/qkrio_scheduled_timer.dart';
import '../theme/style.dart';
import 'qkrio_add_scheduled_dialog.dart';

class QkrioScheduledTile extends StatefulWidget {
  final QkrioScheduledTimer scheduledTimer;
  final VoidCallback onCancelAutoStart;
  final VoidCallback onCancelNotifyBefore;
  final VoidCallback onDelete;

  const QkrioScheduledTile({
    Key? key,
    required this.scheduledTimer,
    required this.onCancelAutoStart,
    required this.onCancelNotifyBefore,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<QkrioScheduledTile> createState() => _QkrioScheduledTileState();
}

class _QkrioScheduledTileState extends State<QkrioScheduledTile> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _isSelected
          ? QkrioStyle.addaptiveLightBackgroundColor(context)
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 170,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 3 / 4,
                    ),
                    child: Text(
                      widget.scheduledTimer.dish.dishName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .textStyle
                          .copyWith(
                            fontSize: CupertinoTheme.of(context)
                                    .textTheme
                                    .textStyle
                                    .fontSize! *
                                1.5,
                            fontWeight: FontWeight.w200,
                          ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      const Text('Start at '),
                      Text(
                        widget.scheduledTimer.startAsString,
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Text('Cooking duration '),
                      Text(
                        widget.scheduledTimer.dish.presentableDuration(),
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3.0),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                if (widget.scheduledTimer.startAutomatically)
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.play_fill),
                    onPressed: widget.onCancelAutoStart,
                  ),
                if (widget.scheduledTimer.notifyBefore != null)
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.bell_fill),
                    onPressed: widget.onCancelNotifyBefore,
                  ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.list_bullet),
                  onPressed: () async {
                    setState(() => _isSelected = true);
                    await _openOptions();
                    setState(() => _isSelected = false);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openOptions() {
    return showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoActionSheet(
            title: Text(widget.scheduledTimer.dish.dishName),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  showCupertinoDialog(
                      context: context,
                      builder: (_) {
                        return QkrioAddScheduledDialog(
                          initialScheduledTimer: widget.scheduledTimer,
                          onAdd: (QkrioScheduledTimer scheduledTimer) =>
                              QkrioBloc.updateScheduledTimer(context,
                                  widget.scheduledTimer, scheduledTimer),
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
