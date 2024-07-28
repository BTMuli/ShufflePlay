// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../pages/main/app_config.dart';
import '../../pages/user/user_gacha.dart';

class AppNavWidget extends StatefulWidget {
  const AppNavWidget({super.key});

  @override
  State<AppNavWidget> createState() => _AppNavWidgetState();
}

class _AppNavWidgetState extends State<AppNavWidget> {
  int selectedIndex = 0;

  static const List<NavigationRailDestination> destinations =
      <NavigationRailDestination>[
    NavigationRailDestination(
      icon: Icon(Icons.favorite_border),
      selectedIcon: Icon(Icons.favorite),
      label: Text('User Gacha'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.settings),
      selectedIcon: Icon(Icons.settings),
      label: Text('App Config'),
    ),
  ];

  Widget getSelectedWidget(int index) {
    switch (index) {
      case 0:
        return const UserGachaPage();
      case 1:
        return const AppConfigPage();
      default:
        return const UserGachaPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            destinations: destinations,
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Center(
              child: getSelectedWidget(selectedIndex),
            ),
          ),
        ],
      ),
    );
  }
}
