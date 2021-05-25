import 'package:flutter/cupertino.dart';

class Separator extends StatelessWidget {
  const Separator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.3,
      width: double.infinity,
      color: CupertinoColors.separator.resolveFrom(context),
    );
  }
}
