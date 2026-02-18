import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int selectedIndex;

  const BottomNav({
    super.key,
    required this.selectedIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard/class');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/dashboard/announcement');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/dashboard/add_person');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.school_outlined),
          label: 'Daftar Kelas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          label: 'Pengumuman',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_add_outlined),
          label: 'Tambah',
        ),
      ],
    );
  }
}
