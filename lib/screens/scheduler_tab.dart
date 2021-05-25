import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/qkrio_bloc.dart';
import '../models/qkrio_scheduled_timer.dart';
import '../theme/style.dart';
import '../widgets/qkrio_add_scheduled_dialog.dart';
import '../widgets/qkrio_scheduled_tile.dart';
import '../widgets/util/separator.dart';

class SchedulerTab extends StatelessWidget {
  const SchedulerTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QkrioBloc, QkrioState>(
      builder: (BuildContext context, QkrioState state) {
        final List<Widget> children = <Widget>[];
        if (state.scheduledTimers.isNotEmpty) {
          children.add(_scheduledTile(context, state.scheduledTimers.first));
          for (int i = 1; i < state.scheduledTimers.length; i++) {
            children.add(const Separator());
            children.add(_scheduledTile(context, state.scheduledTimers[i]));
          }
        }

        return CustomScrollView(
          physics: state.scheduledTimers.isEmpty
              ? const NeverScrollableScrollPhysics()
              : null,
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: const Text('Scheduler'),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.add_circled),
                onPressed: () => _openAddScheduled(context),
              ),
            ),
            if (state.scheduledTimers.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: MediaQuery.of(context).size.height / 3,
                    ),
                    child: Column(
                      children: <Widget>[
                        Icon(
                          CupertinoIcons.zzz,
                          size: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .fontSize! *
                              5,
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          'Nothing is scheduled, relax'.toUpperCase(),
                          style: QkrioStyle.capsInfoText(context),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverList(delegate: SliverChildListDelegate.fixed(children)),
          ],
        );
      },
    );
  }

  void _openAddScheduled(BuildContext context) async {
    return showCupertinoDialog(
        context: context,
        builder: (_) {
          return QkrioAddScheduledDialog(
            onAdd: (QkrioScheduledTimer timer) {
              QkrioBloc.addScheduledTimer(context, timer);
            },
          );
        });
  }

  QkrioScheduledTile _scheduledTile(
      BuildContext context, QkrioScheduledTimer scheduledTimer) {
    return QkrioScheduledTile(
      scheduledTimer: scheduledTimer,
      onCancelAutoStart: () =>
          QkrioBloc.cancelAutostartOnScheduledTimer(context, scheduledTimer),
      onCancelNotifyBefore: () =>
          QkrioBloc.cancelNotifyBeforeOnScheduledTimer(context, scheduledTimer),
      onDelete: () => QkrioBloc.cancelScheduledTimer(context, scheduledTimer),
    );
  }
}
