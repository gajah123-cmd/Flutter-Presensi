import 'package:flutter/material.dart';
import 'package:apk/database/db_kelas.dart';

class FormKelasPage extends StatefulWidget {
  const FormKelasPage({super.key});

  @override
  State<FormKelasPage> createState() => _FormKelasPageState();
}

class _FormKelasPageState extends State<FormKelasPage> {
  final nameClassController = TextEditingController();
  final tahunController = TextEditingController();
  
  int? selectedTingkat;

  List<Map<String, dynamic>> guruList = [];
  List<Map<String, dynamic>> muridList = [];

  String? selectedGuru;
  String? selectedMurid;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final gurus = await ClassService.getGuru();
      final murids = await ClassService.getMurid();
      setState(() {
        guruList = gurus;
        muridList = murids;
      });
    } catch (e) {
      debugPrint("Error loading data: $e");
    }
  }

  Future<void> simpan() async {
    if (nameClassController.text.isEmpty || selectedTingkat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama Kelas dan Tingkat wajib diisi!")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await ClassService.tambahKelas(
        idClass: selectedTingkat!,
        nameClass: nameClassController.text,
        idGuru: selectedGuru,
        idMurid: selectedMurid,
        tahun: tahunController.text.isEmpty ? null : tahunController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kelas berhasil disimpan")),
      );

      // reset form
      nameClassController.clear();
      tahunController.clear();

      setState(() {
        selectedTingkat = null;
        selectedGuru = null;
        selectedMurid = null;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        elevation: 0,
        automaticallyImplyLeading: true,
        // leading: IconButton(
        //   icon: Image.asset('lib/asset/icons/Button.png', width: 30, height: 30),
        //   onPressed: () => Navigator.pop(context),
        // ),
        titleSpacing: -5,
        title: const Text("Form Kelas"),
        titleTextStyle: const TextStyle(
          fontFamily: "Inter",
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Nama Kelas
            const Text("Nama Kelas *"),
            const SizedBox(height: 6),
            TextField(
              controller: nameClassController,
              decoration: InputDecoration(
                hintText: "Contoh: Kelas 1A",
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tingkat
            const Text("Tingkat Kelas *"),
            const SizedBox(height: 6),
            DropdownButtonFormField<int>(
              value: selectedTingkat,
              hint: const Text("Pilih Tingkat / Lain-lain"),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: [
                const DropdownMenuItem(value: 1, child: Text('Kelas 1')),
                const DropdownMenuItem(value: 2, child: Text('Kelas 2')),
                const DropdownMenuItem(value: 3, child: Text('Kelas 3')),
                const DropdownMenuItem(value: 4, child: Text('Kelas 4')),
                const DropdownMenuItem(value: 5, child: Text('Kelas 5')),
                const DropdownMenuItem(value: 6, child: Text('Kelas 6')),
                const DropdownMenuItem(value: 7, child: Text('Lain-lain')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedTingkat = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Tahun Ajaran
            const Text("Tahun Ajaran"),
            const SizedBox(height: 6),
            TextField(
              controller: tahunController,
              decoration: InputDecoration(
                hintText: "Contoh: 2023/2024",
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Guru
            const Text("Pilih Guru"),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedGuru,
              hint: const Text("Pilih Wali Kelas/Guru"),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: guruList.map((guru) {
                return DropdownMenuItem<String>(
                  value: guru['id_tabel'],
                  child: Text(guru['name'] ?? 'Unknown'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGuru = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Murid
            const Text("Pilih Murid"),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedMurid,
              hint: const Text("Pilih Murid (Ketua Kelas dll)"),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: muridList.map((murid) {
                return DropdownMenuItem<String>(
                  value: murid['id_tabel'],
                  child: Text(murid['nama'] ?? 'Unknown'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMurid = value;
                });
              },
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: isLoading ? null : simpan,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: const Color(0xFF2563EB),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text("Simpan", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
