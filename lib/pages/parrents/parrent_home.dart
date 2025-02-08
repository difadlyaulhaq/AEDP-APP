import 'package:flutter/material.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/pages/parrents/parrent_dashboard.dart';
import 'package:project_aedp/theme/theme.dart';
import '../profile_page.dart';
import 'invoice_page.dart';

class ParrentHome extends StatefulWidget {
  const ParrentHome({super.key});

  @override
  State<ParrentHome> createState() => _ParrentHomeState();
}

class _ParrentHomeState extends State<ParrentHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardParentHome(),
    const InvoicePage(),
    const ProfilePage(),
  ];

  void _onNavbarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavbarTap,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home), label: S.of(context).home),
          BottomNavigationBarItem(
              icon: const Icon(Icons.receipt), label: S.of(context).invoice),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person), label: S.of(context).profile),
        ],
      ),
    );
  }
}
