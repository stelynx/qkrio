import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/qkrio_bloc.dart';
import '../models/qkrio_dish.dart';
import '../models/qkrio_timer.dart';
import '../theme/style.dart';
import '../widgets/qkrio_add_favourite_dialog.dart';
import '../widgets/qkrio_favourite_tile.dart';
import '../widgets/util/separator.dart';

class FavouritesTab extends StatelessWidget {
  const FavouritesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QkrioBloc, QkrioState>(
      builder: (context, state) {
        final List<Widget> children = <Widget>[];
        if (state.favouriteDishes.isNotEmpty) {
          children.add(_favouriteTile(context, state.favouriteDishes.first));
          for (int i = 1; i < state.favouriteDishes.length; i++) {
            children.add(const Separator());
            children.add(_favouriteTile(context, state.favouriteDishes[i]));
          }
        }

        return CustomScrollView(
          physics: state.favouriteDishes.isEmpty
              ? const NeverScrollableScrollPhysics()
              : null,
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: const Text('Favourites'),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.add_circled),
                onPressed: () => _openAddNewFavourite(context),
              ),
            ),
            if (state.favouriteDishes.isEmpty)
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
                          CupertinoIcons.star_slash,
                          size: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .fontSize! *
                              5,
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          'You have no favourites ... Yet!'.toUpperCase(),
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

  void _openAddNewFavourite(BuildContext context) async {
    return showCupertinoDialog(
        context: context,
        builder: (_) {
          return QkrioAddFavouriteDialog(
            onAdd: (QkrioDish dish) {
              QkrioBloc.addFavourite(context, dish);
            },
          );
        });
  }

  QkrioFavouriteTile _favouriteTile(BuildContext context, QkrioDish dish) {
    return QkrioFavouriteTile(
      dish: dish,
      onTimerStart: () {
        QkrioBloc.addTimer(
          context,
          QkrioTimer(
            dish: dish,
            started: DateTime.now(),
          ),
          startedFromFavourites: true,
        );
      },
      onDelete: () => QkrioBloc.deleteFavourite(context, dish),
    );
  }
}
