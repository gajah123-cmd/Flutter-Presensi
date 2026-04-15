import 'package:apk/function/bottom_nav.dart';
import 'package:flutter/material.dart';
import '../dashboard/class.dart';
import '../dashboard/announcement.dart';
import '../dashboard/add_person.dart';
  
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const DaftarKelas(),
    const Pengumuman(),
    const TambahPengguna(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),

      bottomNavigationBar: BottomNav(
        selectedIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}