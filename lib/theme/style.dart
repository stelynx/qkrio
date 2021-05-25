import 'package:flutter/cupertino.dart';

abstract class QkrioStyle {
  static BorderRadius borderRadius = BorderRadius.circular(10.0);

  static TextStyle timerTextClock(BuildContext context) =>
      CupertinoTheme.of(context).textTheme.textStyle.copyWith(
            fontSize: 50,
            fontWeight: FontWeight.w200,
          );

  static TextStyle timerTextName(BuildContext context) =>
      CupertinoTheme.of(context).textTheme.textStyle.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w300,
          );

  static TextStyle capsInfoText(BuildContext context) =>
      CupertinoTheme.of(context)
          .textTheme
          .textStyle
          .copyWith(fontWeight: FontWeight.w300);

  static Color addaptiveLightBackgroundColor(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.light
        ? CupertinoColors.lightBackgroundGray
        : CupertinoColors.systemGrey;
  }
}
