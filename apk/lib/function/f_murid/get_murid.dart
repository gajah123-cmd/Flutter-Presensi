import 'package:apk/function/f_murid/update_murid.dart';
import 'package:flutter/material.dart';
import 'package:apk/database/db_siswa.dart';
import 'package:apk/function/custom_button.dart';

class MuridPage extends StatefulWidget {
  const MuridPage({super.key});

  @override
  State<MuridPage> createState() => _MuridPageState();
}

class _MuridPageState extends State<MuridPage> {
  final MuridService service = MuridService();

  List<Map<String, dynamic>> muridList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  String? errorMessage;

  Future<void> loadData() async {
    try {
      final data = await service.getMurid();
      setState(() {
        muridList = data;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
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
      appBar: AppBar(title: const Text("Manajemen Murid")),
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
              : muridList.isEmpty
                  ? const Center(
                      child: Text(
                        "Belum ada data murid",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
              itemCount: muridList.length,
              itemBuilder: (context, index) {
                final m = muridList[index];

                return CustomCard(
                  title: "${safe(m['nama'])}",
                  subtitle: "NIS: ${safe(m['nis'])}",
                  customIcon: Image.asset(
                    'lib/asset/icons/b_people.png',
                    width: 35,
                    height: 35,
                  ),
                  iconDecoration: BoxDecoration(
                    color: Colors.lightBlueAccent[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  iconPosition: IconPosition.left,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailMuridPage(data: m),
                      ),
                    );

                    // refresh setelah balik
                    loadData();
                  },
                );
              },
            ),
    );
  }
}