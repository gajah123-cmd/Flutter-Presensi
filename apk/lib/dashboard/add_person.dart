import 'package:flutter/material.dart';
import 'package:apk/widget.dart';

class TambahPengguna extends StatefulWidget {
  const TambahPengguna({super.key});

    @override
  State<TambahPengguna> createState() => _TambahPenggunaState();
}

class _TambahPenggunaState extends State<TambahPengguna> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(selectedIndex: 2),
      appBar: AppBar(
        title: const Text('Tambah Pengguna'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 4,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DialogTambahSiswa(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFFE3ECFF),
                    child: Icon(
                      Icons.person_add_alt_1,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Tambahkan Akun Murid",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
