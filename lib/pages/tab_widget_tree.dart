import 'package:flutter/material.dart';
import 'package:interactive_learn/pages/tabs/home_page.dart';
import 'package:interactive_learn/pages/tabs/profile_page.dart';
import 'package:interactive_learn/pages/tabs/search_page.dart';

class TabWidgetTree extends StatefulWidget {
  const TabWidgetTree({super.key});

  @override
  State<TabWidgetTree> createState() => _TabWidgetTreeState();
}

class _TabWidgetTreeState extends State<TabWidgetTree> {
  int _selectedIndex = 0;

 final List<Widget> _widgets = <Widget>[
    HomePage(),
    SearchPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tab Widget Tree')),
      body: SingleChildScrollView(
        child: _widgets[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
