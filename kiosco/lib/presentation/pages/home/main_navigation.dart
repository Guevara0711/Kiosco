import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:kiosco/presentation/pages/home/home_page.dart';
import 'package:kiosco/presentation/pages/orders/my_orders_page.dart';
import 'package:kiosco/presentation/pages/favorites/favorites_page.dart';
import 'package:kiosco/presentation/pages/profile/profile_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const MyOrdersPage(), 
    const FavoritesPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: _pages,
      ),
      bottomNavigationBar: FBottomNavigationBar(
        index: index,
        onChange: (newIndex) => setState(() => index = newIndex),
        children: [
          FBottomNavigationBarItem(
            icon: Icon(FIcons.house),
            label: const Text('Home'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.shoppingCart),
            label: const Text('Cart'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.heart),
            label: const Text('Favorite'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.user),
            label: const Text('My Profile'),
          ),
        ],
      ),
    );
  }
}
