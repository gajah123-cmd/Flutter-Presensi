import 'package:flutter/material.dart';
import 'package:apk/function/custom_button.dart';
import 'package:apk/function/f_pesan/grup_sekolah.dart';
import 'package:apk/database/db_guru.dart';
import 'package:apk/database/db_siswa.dart';
import 'package:apk/function/f_pesan/chat_private.dart';

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
              padding: const EdgeInsets.all(24.0),
              children: [
                CustomCard(
                  title: 'Grup Sekolah',
                  subtitle: 'Informasi dan diskusi seluruh sekolah',
                  iconPosition: IconPosition.left,
                  icon: Icons.account_balance_outlined,
                  iconColor: const Color(0xFF2563EB),
                  iconDecoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.white,
                  borderColor: Colors.transparent,
                  borderWidth: 0,
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GrupSekolah()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text('List Guru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                const SizedBox(height: 10),
                ..._listGuru.map((guru) {
                  final nama = guru['name'] ?? '-';
                  final isWali = guru['wali'] == true;
                  final roleText = isWali ? 'Wali Kelas' : 'Guru Mapel';
                  final kelas = guru['class_name']?['name_class'] ?? 'Belum ada kelas';
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
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
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFEFF6FF),
                                  border: Border.all(color: const Color(0xFF2563EB), width: 1.5),
                                ),
                                child: const Center(
                                  child: Icon(Icons.person, color: Color(0xFF2563EB), size: 28),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nama,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF1F5F9),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            roleText,
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF475569),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEFF6FF),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: const Color(0xFFDBEAFE)),
                                          ),
                                          child: Text(
                                            kelas,
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF2563EB),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 20),
                const Text('List Murid', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                const SizedBox(height: 10),
                ..._listMurid.map((murid) {
                  final nama = murid['nama'] ?? '-';
                  final kelas = murid['class_name']?['name_class'] ?? 'Belum ada kelas';
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
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
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFEFF6FF),
                                  border: Border.all(color: const Color(0xFF2563EB), width: 1.5),
                                ),
                                child: const Center(
                                  child: Icon(Icons.school, color: Color(0xFF2563EB), size: 28),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nama,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEFF6FF),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: const Color(0xFFDBEAFE)),
                                          ),
                                          child: Text(
                                            kelas,
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF2563EB),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
    );
  }
}
