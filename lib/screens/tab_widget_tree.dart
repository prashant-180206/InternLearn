import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:interactive_learn/screens/tabs/home_screen.dart';
import 'package:interactive_learn/screens/tabs/profile_screen.dart';
import 'package:interactive_learn/screens/tabs/search_screen.dart';
import 'package:interactive_learn/screens/tabs/progress_screen.dart';

class TabWidgetTree extends HookWidget {
  const TabWidgetTree({super.key});

  static const _pages = [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
    ProgressScreen(),
  ];

  static const _titles = ['Home', 'Search', 'Profile','Progress'];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[selectedIndex.value]),
      ),
      body: _pages[selectedIndex.value],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex.value,
        onDestinationSelected: (index) => selectedIndex.value = index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.show_chart), selectedIcon: Icon(Icons.show_chart), label: 'Progress',
          ),
        ],
      ),
    );
  }
}
