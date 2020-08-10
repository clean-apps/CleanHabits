import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int index;
  BottomNavBar({this.index});

  List<BottomNavigationBarItem> _navElements() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.view_day),
        title: Text('Today'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.insert_chart),
        title: Text('Progress'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        title: Text('Settings'),
      ),
    ];
  }

  _handleNavChange(context, index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/');
        break;
      case 1:
        Navigator.pushNamed(context, '/progress');
        break;
      case 2:
        Navigator.pushNamed(context, '/settings');
        break;
      default:
        debugPrint('nav changed to $index');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        items: _navElements(),
        currentIndex: this.index,
        selectedItemColor: Theme.of(context).accentColor,
        onTap: (index) => _handleNavChange(context, index));
  }
}
