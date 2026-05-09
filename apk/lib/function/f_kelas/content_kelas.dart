import 'package:flutter/material.dart';
import 'package:apk/database/db_kelas.dart';
import 'package:apk/function/custom_button.dart';
import 'package:apk/function/f_kelas/update_kelas.dart';

class ContentKelas extends StatefulWidget {
  final Map<String, dynamic> classData;

  const ContentKelas({super.key, required this.classData});

  @override
  State<ContentKelas> createState() => _ContentKelasState();
}

class _ContentKelasState extends State<ContentKelas> {
  List<Map<String, dynamic>> muridList = [];
  List<Map<String, dynamic>> guruList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final String classId = widget.classData['id_tabel'];
      final resMurid = await ClassService.getMuridByClass(classId);
      final resGuru = await ClassService.getGuruByClass(classId);
      
      setState(() {
        muridList = resMurid ?? [];
        guruList = resGuru ?? [];
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final nameClass = widget.classData['name_class'] ?? 'Tanpa Nama';
    
    String guruName = '-';
    if (widget.classData['guru'] is List) {
      final List gurus = widget.classData['guru'] as List;
      final waliGuru = gurus.firstWhere((g) => g['wali'] == true, orElse: () => null);
      if (waliGuru != null) {
        guruName = waliGuru['name']?.toString() ?? '-';
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          nameClass,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text(
                widget.classData['tahun'] ?? '-',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateKelasPage(classData: widget.classData),
                    ),
                  ).then((result) {
                    if (result != null && result is Map<String, dynamic>) {
                      setState(() {
                        widget.classData['name_class'] = result['name_class'];
                        widget.classData['id_class'] = result['id_class'];
                        widget.classData['tahun'] = result['tahun'];
                      });
                    }
                    loadData(); // Refresh data after returning
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
                    padding: const EdgeInsets.only(bottom: 20),
                    children: [
                      // --- BAGIAN GURU ---
                      if (guruList.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Daftar Guru",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ),
                        ),
                        ...guruList.map((g) {
                          final isWali = g['wali'] == true;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                            child: CustomCard(
                              title: g['name'] ?? 'Tanpa Nama',
                              subtitle: isWali ? "Wali Kelas" : "Guru Mapel: ${g['bidang'] ?? '-'}",
                              iconPosition: IconPosition.left,
                              icon: Icons.person,
                              iconColor: isWali ? Colors.green[700]! : const Color(0xFF2563EB),
                              iconDecoration: BoxDecoration(
                                color: isWali ? Colors.green[100] : const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.white,
                              borderColor: Colors.transparent,
                              borderWidth: 0,
                              margin: EdgeInsets.zero,
                              onTap: () {},
                            ),
                          );
                        }),
                      ],

                      // --- BAGIAN MURID ---
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20, bottom: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Daftar Murid",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ),
                      if (muridList.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: Text(
                              "Belum ada murid di kelas ini",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 80, // Tinggi tetap (fixed height)
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: muridList.length,
                          itemBuilder: (context, index) {
                            final m = muridList[index];
                            return CustomCard(
                              title: m['nama'] ?? 'Tanpa Nama',
                              subtitle: "NIS: ${m['nis'] ?? '-'}",
                              iconPosition: IconPosition.left,
                              icon: Icons.person,
                              iconColor: const Color(0xFF2563EB),
                              iconDecoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.white,
                              borderColor: Colors.transparent,
                              borderWidth: 0,
                              margin: EdgeInsets.zero,
                              onTap: () {},
                            );
                          },
                        ),
                    ],
                  ),
    );
  }
}
