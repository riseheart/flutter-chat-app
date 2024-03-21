import 'package:chatapp/chat/chat.dart';
import 'package:chatapp/dashboard/dashboard.dart';
import 'package:chatapp/home/home.dart';
import 'package:chatapp/profile/profile.dart';
import 'package:chatapp/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});
  static Page<void> page() => const MaterialPage<void>(child: Dashboard());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavigationCubit(),
      child: Scaffold(
        body: BlocBuilder<BottomNavigationCubit, BottomNavItem>(
          builder: (context, state) {
            switch (state) {
              case BottomNavItem.home:
                return HomePage();
              case BottomNavItem.search:
                return SearchPage();
              case BottomNavItem.chat:
                return ChatListPage();
              case BottomNavItem.profile:
                return ProfilePage();
            }
          },
        ),
        bottomNavigationBar: BlocBuilder<BottomNavigationCubit, BottomNavItem>(
          builder: (context, state) {
            return BottomNavigationBar(
              currentIndex: state.index,
              onTap: (index) {
                context
                    .read<BottomNavigationCubit>()
                    .changePage(BottomNavItem.values[index]);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.chat), label: 'Messenger'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Profile'),
              ],
              selectedItemColor: Colors.deepPurple,
              unselectedItemColor: Colors.grey,
              elevation: 8,
            );
          },
        ),
      ),
    );
  }
}
