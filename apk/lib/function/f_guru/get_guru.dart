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
      appBar: AppBar(
        title: const Text("Daftar Guru"),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
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
                  : ListView.builder(
                      itemCount: guruList.length,
                      itemBuilder: (context, index) {
                        final g = guruList[index];
                        final isWali = g['wali'] == true;
                        String subtitle = "NIK: ${safe(g['nik'])}";
                        
                        if (isWali) {
                          final className = g['class_name']?['name_class'] ?? 'Tanpa Kelas';
                          subtitle += "\nWali Kelas: $className";
                        } else if (g['bidang'] != null && g['bidang'].toString().isNotEmpty) {
                          subtitle += "\nBidang: ${g['bidang']}";
                        }

                        return CustomCard(
                          title: "${safe(g['name'])}",
                          subtitle: subtitle,
                          customIcon: Image.asset(
                            'lib/asset/icons/h_hat.png',
                            width: 35,
                            height: 35,
                          ),
                          iconDecoration: BoxDecoration(
                            color: Colors.greenAccent[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          iconPosition: IconPosition.left,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailGuruPage(data: g),
                              ),
                            );
                            loadData();
                          },
                        );
                      },
                    ),
    );
  }
}
