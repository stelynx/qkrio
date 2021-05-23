import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/qkrio_bloc.dart';
import 'screens/favourites_tab.dart';
import 'screens/timers_tab.dart';
import 'services/local_storage.dart';
import 'services/notification.dart';
import 'theme/theme.dart';

void main() async {
  runApp(const QkrioApp());
}

class QkrioApp extends StatelessWidget {
  const QkrioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Qkrio',
      debugShowCheckedModeBanner: false,
      theme: qkrioTheme,
      home: BlocProvider(
        create: (_) => QkrioBloc(
          localStorageService: LocalStorageService(),
          notificationService: NotificationService(),
        ),
        child: const QkrioHome(),
        lazy: false,
      ),
    );
  }
}

class QkrioHome extends StatelessWidget {
  const QkrioHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QkrioBloc, QkrioState>(
      builder: (context, state) {
        if (!state.isLoaded) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.timer),
                label: 'Timers',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.star),
                label: 'Favourites',
              ),
            ],
          ),
          tabBuilder: (BuildContext context, int index) {
            switch (index) {
              case 0:
                return const TimersTab();
              case 1:
                return const FavouritesTab();
              default:
                throw UnimplementedError();
            }
          },
        );
      },
    );
  }
}
