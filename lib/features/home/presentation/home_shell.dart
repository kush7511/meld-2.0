import 'package:flutter/material.dart';

import '../../calls/presentation/calls_screen.dart';
import '../../chat/presentation/chat_list_screen.dart';
import '../../groups/presentation/groups_screen.dart';
import '../../profile/presentation/profile_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  static const routeName = '/home';

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _screens = const [
    ChatListScreen(),
    CallsScreen(),
    GroupsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: _index == 1 ? 'New call' : 'New chat',
        child: Icon(_index == 1 ? Icons.add_call : Icons.edit_rounded),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        backgroundColor: Colors.white,
        indicatorColor: Theme.of(context).colorScheme.primaryContainer,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            icon: Icon(Icons.chat_bubble_outline_rounded),
            label: 'Chats',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.call_rounded),
            icon: Icon(Icons.call_outlined),
            label: 'Calls',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.groups_rounded),
            icon: Icon(Icons.groups_outlined),
            label: 'Groups',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person_rounded),
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
