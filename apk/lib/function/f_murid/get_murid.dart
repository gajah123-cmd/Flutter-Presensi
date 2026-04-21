import 'package:apk/function/f_murid/update_murid.dart';
import 'package:flutter/material.dart';
import 'package:apk/database/db_siswa.dart';

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

  Future<void> loadData() async {
    final data = await service.getMurid();
    setState(() {
      muridList = data;
      isLoading = false;
    });
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
          : ListView.builder(
              itemCount: muridList.length,
              itemBuilder: (context, index) {
                final m = muridList[index];

                return Card(
                  child: ListTile(
                    title: Text("${safe(m['nama'])}"),
                    subtitle: Text("NIS: ${safe(m['nis'])}"),
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
                  ),
                );
              },
            ),
    );
  }
}