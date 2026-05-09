import 'package:flutter/material.dart';
import 'package:apk/database/db_guru.dart';
import 'package:apk/function/custom_button.dart';
import 'package:apk/function/f_guru/update_guru.dart';

class GuruPage extends StatefulWidget {
  const GuruPage({super.key});

  @override
  State<GuruPage> createState() => _GuruPageState();
}

class _GuruPageState extends State<GuruPage> {
  List<Map<String, dynamic>> guruList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final data = await GuruService.getGuru();
      setState(() {
        guruList = data;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  String safe(dynamic value) {
    if (value == null || value.toString().isEmpty) return "N/A";
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manajemen Guru")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Terjadi Kesalahan:\n$errorMessage",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                )
              : guruList.isEmpty
                  ? const Center(
                      child: Text(
                        "Belum ada data guru",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.builder(
                            itemCount: guruList.length,
                            itemBuilder: (context, index) {
                              final g = guruList[index];
                              final nama = safe(g['name']);
                              final nik = safe(g['nik']);
                              final isWali = g['wali'] == true;
                              final kelas = g['class_name']?['name_class'] ??
                                  'Belum ada kelas';
                              final bidang = safe(g['bidang']);
                              final detail = isWali
                                  ? 'Wali Kelas: $kelas'
                                  : 'Bidang: $bidang';

                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 0,
                                    ),
                                    child: CustomCard(
                                      title: nama,
                                      subtitle: 'NIK: $nik\n$detail',
                                      iconPosition: IconPosition.left,
                                      icon: Icons.person,
                                      iconColor: const Color(0xFF2563EB),
                                      iconDecoration: BoxDecoration(
                                        color: const Color(0xFFEFF6FF),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      backgroundColor: Colors.white,
                                      borderColor: Colors.transparent,
                                      borderWidth: 0,
                                      margin: EdgeInsets.zero,
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                DetailGuruPage(data: g),
                                          ),
                                        );
                                        loadData();
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
    );
  }
}
