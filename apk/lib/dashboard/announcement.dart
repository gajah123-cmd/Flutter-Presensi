import 'package:flutter/material.dart';
//import 'package:apk/function/bottom_nav.dart';

class Pengumuman extends StatefulWidget {
  const Pengumuman({super.key});

  @override
  State<Pengumuman> createState() => _PengumumanState();
}

class _PengumumanState extends State<Pengumuman> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // bottomNavigationBar: const BottomNav(selectedIndex: 1),
      appBar: AppBar(
        //toolbarHeight: 100,
        titleSpacing: 20,
        title: const Text('Pengumuman Sekolah'),
        titleTextStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF2563EB),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.refresh, 
              color: Colors.white),
              onPressed: () {
                setState(() {});
              },
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('Halaman '),
      ),
    );
  }
}
