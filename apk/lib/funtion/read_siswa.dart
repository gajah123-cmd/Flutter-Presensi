import 'package:flutter/material.dart';
import '../Services/siswa_service.dart';

class DaftarSiswaPage extends StatelessWidget {
  const DaftarSiswaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Siswa"),
      ),
      body: FutureBuilder(
        future: SiswaService.getDaftarSiswa(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada data siswa"));
          }

          final data = snapshot.data as List;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final siswa = data[index];
              final detail = siswa['id_siswa'];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  title: Text(detail['name']),
                  subtitle: Text("NIS: ${detail['nis']}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}