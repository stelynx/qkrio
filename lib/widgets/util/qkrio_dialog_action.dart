import 'package:flutter/cupertino.dart';

class QkrioDialogAction extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDefaultAction;
  final bool isDestructiveAction;
  final bool enabled;

  const QkrioDialogAction({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoDialogAction(
      child: Text(
        text,
        style: CupertinoTheme.of(context).textTheme.actionTextStyle.copyWith(
              color: (isDestructiveAction
                      ? CupertinoColors.destructiveRed
                      : CupertinoTheme.of(context).primaryColor)
                  .withOpacity(enabled ? 1.0 : 0.5),
              fontWeight: isDefaultAction ? FontWeight.w600 : null,
            ),
      ),
      onPressed: enabled ? onPressed : null,
    );
  }
}
