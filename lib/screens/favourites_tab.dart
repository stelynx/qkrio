import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/qkrio_bloc.dart';
import '../models/qkrio_dish.dart';
import '../widgets/qkrio_add_favourite_dialog.dart';
import '../widgets/qkrio_favourite_tile.dart';

class FavouritesTab extends StatelessWidget {
  const FavouritesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QkrioBloc, QkrioState>(
      builder: (context, state) {
        final List<Widget> children =
            state.favouriteDishes.map<Widget>((QkrioDish dish) {
          return QkrioFavouriteTile(
            dish: dish,
            onDelete: () => QkrioBloc.deleteFavourite(context, dish),
          );
        }).toList();

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
                          style: const TextStyle(fontWeight: FontWeight.w300),
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
}
