import 'package:flutter/material.dart';
import 'Services/siswa_service.dart';

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
          icon: Icon(Icons.person_add_alt_1_outlined),
          label: 'Tambah',
        ),
      ],
    );
  }
}

class DialogTambahSiswa extends StatefulWidget {
  const DialogTambahSiswa({super.key});

  @override
  State<DialogTambahSiswa> createState() => _DialogTambahSiswaState();
}

class _DialogTambahSiswaState extends State<DialogTambahSiswa> {

  final nisController = TextEditingController();
  final nameController = TextEditingController();
  final tglLahirController = TextEditingController();
  final genderController = TextEditingController();
  final addressController = TextEditingController();
  final noTlpController = TextEditingController();
  final statusController = TextEditingController();

  Future<void> submit() async {
    try {
      await SiswaService.tambahSiswa(
        nis: int.parse(nisController.text),
        name: nameController.text,
        tglLahir: tglLahirController.text,
        gender: genderController.text,
        address: addressController.text,
        noTlp: int.parse(noTlpController.text),
        status: statusController.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil ditambahkan')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data Tidak Valid')),
      );
    }
  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Input Data Siswa'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              TextField(
                controller: nisController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'NIS'),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: tglLahirController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Lahir (YYYY-MM-DD)',
                ),
              ),
              TextField(
                controller: genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Alamat'),
              ),
              TextField(
                controller: noTlpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'No Tlp Orang Tua'),
              ),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Status'),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submit,
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
