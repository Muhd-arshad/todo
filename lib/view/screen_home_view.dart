import 'package:flutter/material.dart';
import 'package:todo/view/screen_category.dart';
import 'package:todo/view/setting_screen.dart';
import 'package:todo/view/task_screen.dart';

class ScreenHomeView extends StatefulWidget {
  final int index;
  const ScreenHomeView({super.key, required this.index});

  @override
  State<ScreenHomeView> createState() => _ScreenHomeViewState();
}

class _ScreenHomeViewState extends State<ScreenHomeView> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    ScreenCategory(),
    TaskScreen(),
    SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amberAccent,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
