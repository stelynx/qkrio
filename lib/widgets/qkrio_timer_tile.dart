import 'package:flutter/cupertino.dart';

import '../models/qkrio_timer.dart';
import '../theme/style.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
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
              ),
              const SizedBox(height: 8.0),
            ],
          ),
          Row(
            children: <Widget>[
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(qkrioTimer.dish.isFavourite
                    ? CupertinoIcons.star_fill
                    : CupertinoIcons.star),
                onPressed: onToggleFavourite,
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(
                  CupertinoIcons.xmark,
                  color: CupertinoColors.destructiveRed,
                ),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
