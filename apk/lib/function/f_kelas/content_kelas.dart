import 'package:flutter/material.dart';
import 'package:apk/database/db_kelas.dart';

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
        muridList = resMurid;
        guruList = resGuru;
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
        title: Text("Detail $nameClass"),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nameClass,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.white70, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Wali Kelas: $guruName",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white70, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Tahun Ajaran: ${widget.classData['tahun'] ?? '-'}",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
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
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: CircleAvatar(
                                backgroundColor: isWali ? Colors.green[100] : Colors.blue[50],
                                child: Icon(
                                  Icons.person,
                                  color: isWali ? Colors.green[700] : Colors.blue[700],
                                ),
                              ),
                              title: Text(
                                g['name'] ?? 'Tanpa Nama',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(isWali ? "Wali Kelas" : "Guru Mapel: ${g['bidang'] ?? '-'}"),
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
                        ...muridList.map((m) {
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFFEFF6FF),
                                child: Text(
                                  (m['nama'] ?? '?').toString().substring(0, 1).toUpperCase(),
                                  style: const TextStyle(
                                    color: Color(0xFF2563EB),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                m['nama'] ?? 'Tanpa Nama',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text("NIS: ${m['nis'] ?? '-'}"),
                            ),
                          );
                        }),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
