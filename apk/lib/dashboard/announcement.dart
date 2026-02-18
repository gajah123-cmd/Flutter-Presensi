import 'package:flutter/material.dart';
import 'package:apk/widget.dart';

class Pengumuman extends StatefulWidget {
  const Pengumuman({super.key});

  @override
  State<Pengumuman> createState() => _PengumumanState();
}

class _PengumumanState extends State<Pengumuman> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(selectedIndex: 1),
      appBar: AppBar(
        title: const Text('Pengumuman'),
        elevation: 0,
      ),
      body: const Center(
        child: Text('Halaman '),
      ),
    );
  }
}
