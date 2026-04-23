import 'package:flutter/material.dart';
import 'package:apk/database/db_guru.dart';

class FormGuruPage extends StatefulWidget {
  const FormGuruPage({super.key});

  @override
  State<FormGuruPage> createState() => _FormGuruPageState();
}

class _FormGuruPageState extends State<FormGuruPage> {
  final nikController = TextEditingController();
  final namaController = TextEditingController();
  final bidangController = TextEditingController();

  List<Map<String, dynamic>> kelasList = [];
  String? selectedClass;
  bool isWali = false;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadKelas();
  }

  Future<void> loadKelas() async {
    final data = await GuruService.getKelas();
    setState(() {
      kelasList = data;
    });
  }

  Future<void> simpan() async {
    if (nikController.text.isEmpty || namaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("NIK dan Nama wajib diisi!")),
      );
      return;
    }

    if (isWali && selectedClass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kelas wajib dipilih jika menjadi Wali Kelas!")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await GuruService.tambahGuru(
        nik: num.parse(nikController.text),
        name: namaController.text,
        bidang: bidangController.text.isEmpty ? null : bidangController.text,
        idClass: selectedClass,
        wali: isWali,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data guru berhasil disimpan")),
      );

      // reset form
      nikController.clear();
      namaController.clear();
      bidangController.clear();

      setState(() {
        selectedClass = null;
        isWali = false;
      });

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    }

    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Image.asset('lib/asset/icons/Button.png', width: 30, height: 30),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: -5,
        title: const Text("Form Guru"),
        titleTextStyle: const TextStyle(
          fontFamily: "Inter",
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // NIK
            const Text("NIK *"),
            const SizedBox(height: 6),
            TextField(
              controller: nikController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Masukkan NIK Guru",
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

            // Nama
            const Text("Nama Lengkap *"),
            const SizedBox(height: 6),
            TextField(
              controller: namaController,
              decoration: InputDecoration(
                hintText: "Nama Lengkap Guru",
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

            // Bidang
            const Text("Bidang Mata Pelajaran"),
            const SizedBox(height: 6),
            TextField(
              controller: bidangController,
              decoration: InputDecoration(
                hintText: "Contoh: Matematika",
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

            // Wali Kelas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Wali Kelas", style: TextStyle(fontWeight: FontWeight.w600)),
                Switch(
                  value: isWali,
                  activeColor: const Color(0xFF2563EB),
                  onChanged: (val) {
                    setState(() {
                      isWali = val;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Kelas
            const Text("Pilih Kelas (Wajib jika Wali Kelas)"),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedClass,
              hint: const Text("Pilih Kelas"),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: kelasList.map((kelas) {
                return DropdownMenuItem<String>(
                  value: kelas['id_tabel'],
                  child: Text(kelas['name_class']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedClass = value;
                });
              },
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: isLoading ? null : simpan,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Simpan", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
