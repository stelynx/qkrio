import 'package:flutter/cupertino.dart';

import '../models/qkrio_timer.dart';
import '../theme/style.dart';
import 'util/qkrio_dialog_action.dart';

class QkrioTimerTile extends StatelessWidget {
  final QkrioTimer qkrioTimer;
  final VoidCallback onToggleFavourite;
  final VoidCallback onDelete;

  const QkrioTimerTile({
    Key? key,
    required this.qkrioTimer,
    required this.onToggleFavourite,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
        return true;
      },
      dismissThresholds: const <DismissDirection, double>{
        DismissDirection.endToStart: 0.25,
      },
      background: Container(
        color: CupertinoColors.destructiveRed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const <Widget>[
            Icon(
              CupertinoIcons.xmark,
              color: CupertinoColors.white,
            ),
            SizedBox(width: 16.0),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 150,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    qkrioTimer.presentableTime(),
                    style: QkrioStyle.timerTextClock(context),
                  ),
                  Text(
                    qkrioTimer.dish.dishName,
                    style: QkrioStyle.timerTextName(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                if (qkrioTimer.dish.note != null)
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.info),
                    onPressed: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text(qkrioTimer.dish.dishName),
                            content: Text(qkrioTimer.dish.note ??
                                'This dish does not have a note'),
                            actions: <QkrioDialogAction>[
                              QkrioDialogAction(
                                text: 'Close',
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(qkrioTimer.dish.isFavourite
                      ? CupertinoIcons.star_fill
                      : CupertinoIcons.star),
                  onPressed: onToggleFavourite,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
