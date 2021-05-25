import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qkrio/widgets/util/separator.dart';

import '../bloc/qkrio_bloc.dart';
import '../models/qkrio_timer.dart';
import '../theme/style.dart';
import '../widgets/qkrio_add_timer_dialog.dart';
import '../widgets/qkrio_timer_tile.dart';

class TimersTab extends StatelessWidget {
  const TimersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QkrioBloc, QkrioState>(
      builder: (context, state) {
        final List<Widget> children = <Widget>[];
        if (state.runningTimers.isNotEmpty) {
          children.add(_timerTile(context, state.runningTimers.first));
          for (int i = 1; i < state.runningTimers.length; i++) {
            children.add(const Separator());
            children.add(_timerTile(context, state.runningTimers[i]));
          }
        }

        return CustomScrollView(
          physics: state.runningTimers.isEmpty
              ? const NeverScrollableScrollPhysics()
              : null,
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text(state.runningTimers.isEmpty
                  ? 'Nothing is cooking'
                  : 'Currently cooking'),
              trailing: state.runningTimers.isEmpty
                  ? null
                  : CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(CupertinoIcons.add_circled),
                      onPressed: () => _openAddNewTimer(context),
                    ),
            ),
            if (state.runningTimers.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: MediaQuery.of(context).size.height / 3,
                    ),
                    child: GestureDetector(
                      child: Column(
                        children: [
                          Icon(
                            CupertinoIcons.add_circled,
                            size: CupertinoTheme.of(context)
                                    .textTheme
                                    .textStyle
                                    .fontSize! *
                                5,
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            'Start by adding a timer'.toUpperCase(),
                            style: QkrioStyle.capsInfoText(context),
                          ),
                        ],
                      ),
                      onTap: () => _openAddNewTimer(context),
                    ),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildListDelegate.fixed(children),
              ),
          ],
        );
      },
    );
  }

  void _openAddNewTimer(BuildContext context) async {
    return showCupertinoDialog(
        context: context,
        builder: (_) {
          return QkrioAddTimerDialog(
            onAdd: (QkrioTimer timer) {
              QkrioBloc.addTimer(context, timer);
            },
          );
        });
  }

  QkrioTimerTile _timerTile(BuildContext context, QkrioTimer timer) {
    return QkrioTimerTile(
      qkrioTimer: timer,
      onToggleFavourite: () => QkrioBloc.toggleFavouriteOnTimer(context, timer),
      onDelete: () => QkrioBloc.cancelTimer(context, timer),
    );
  }
}
