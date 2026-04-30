import 'package:flutter/material.dart';
import 'package:apk/function/custom_button.dart';
import 'package:apk/function/f_pesan/grup_sekolah.dart';
import 'package:apk/database/db_guru.dart';
import 'package:apk/database/db_siswa.dart';
import 'package:apk/function/f_pesan/chat_private.dart';
//import 'package:apk/function/bottom_nav.dart';

class Pengumuman extends StatefulWidget {
  const Pengumuman({super.key});

  @override
  State<Pengumuman> createState() => _PengumumanState();
}

class _PengumumanState extends State<Pengumuman> {
  final MuridService _muridService = MuridService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _listGuru = [];
  List<Map<String, dynamic>> _listMurid = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final guruRes = await GuruService.getGuru();
      final muridRes = await _muridService.getMurid();
      if (mounted) {
        setState(() {
          _listGuru = guruRes;
          _listMurid = muridRes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

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
                setState(() {
                  _isLoading = true;
                });
                _loadData();
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CustomCard(
                  title: 'Grup Sekolah',
                  icon: Icons.groups,
                  iconColor: const Color(0xFF2563EB),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GrupSekolah()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text('Data Guru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                const SizedBox(height: 10),
                ..._listGuru.map((guru) {
                  final nama = guru['name'] ?? '-';
                  final isWali = guru['wali'] == true;
                  final waliText = isWali ? 'Wali Kelas: Iya' : 'Wali Kelas: Bukan';
                  final kelas = guru['class_name']?['name_class'] ?? 'Belum ada kelas';
                  
                  return CustomCard(
                    title: nama,
                    subtitle: '$waliText\nKelas: $kelas',
                    icon: Icons.chat,
                    iconColor: const Color(0xFF2563EB),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPrivate(
                            receiverId: guru['id_tabel'],
                            receiverType: 'guru',
                            receiverName: nama,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
                const SizedBox(height: 20),
                const Text('Data Murid', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                const SizedBox(height: 10),
                ..._listMurid.map((murid) {
                  final nama = murid['nama'] ?? '-';
                  final kelas = murid['class_name']?['name_class'] ?? 'Belum ada kelas';
                  
                  return CustomCard(
                    title: nama,
                    subtitle: 'Kelas: $kelas',
                    icon: Icons.chat,
                    iconColor: const Color(0xFF2563EB),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPrivate(
                            receiverId: murid['id_tabel'],
                            receiverType: 'murid',
                            receiverName: nama,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ],
            ),
    );
  }
}
