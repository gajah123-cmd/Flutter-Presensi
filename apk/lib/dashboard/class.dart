import 'package:flutter/material.dart';
import 'package:apk/widget.dart';

class DaftarKelas extends StatefulWidget {
  const DaftarKelas({super.key});

  @override
  State<DaftarKelas> createState() => _DaftarKelasState();
}

class _DaftarKelasState extends State<DaftarKelas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(selectedIndex: 0),
      appBar: AppBar(
        title: const Text('Daftar Kelas'),
        elevation: 0,
      ),
      body: const Center(
        child: Text('Halaman'),
      ),
    );
  }
}
