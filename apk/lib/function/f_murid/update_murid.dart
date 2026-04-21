/// ===========================================
/// DETAIL_MURID_PAGE.DART
/// ===========================================

import 'package:flutter/material.dart';
import 'package:apk/database/db_siswa.dart';

class DetailMuridPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const DetailMuridPage({
    super.key,
    required this.data,
  });

  @override
  State<DetailMuridPage> createState() => _DetailMuridPageState();
}

class _DetailMuridPageState extends State<DetailMuridPage> {
  final service = MuridService();

  bool edit = false;

  late TextEditingController namaC;
  late TextEditingController genderC;
  late TextEditingController tglC;
  late TextEditingController alamatC;
  late TextEditingController ortuC;
  late TextEditingController teleC;

  List<Map<String, dynamic>> kelasList = [];
  int? selectedKelas;

  @override
  void initState() {
    super.initState();

    namaC = TextEditingController(text: widget.data['nama'] ?? "");
    genderC = TextEditingController(text: widget.data['gender'] ?? "");
    tglC = TextEditingController(
      text: widget.data['tanggal_lahir']?.toString() ?? "",
    );
    alamatC = TextEditingController(text: widget.data['alamat'] ?? "");
    ortuC = TextEditingController(text: widget.data['orang_tua'] ?? "");
    teleC = TextEditingController(
      text: widget.data['no_tele']?.toString() ?? "",
    );

    selectedKelas = widget.data['id_class'];

    loadKelas();
  }

  Future<void> loadKelas() async {
    final data = await service.getKelas();
    setState(() => kelasList = data);
  }

  Future<void> updateData() async {
    await service.updateMurid(
      idTabel: widget.data['id_tabel'], // 🔥 pakai PK baru
      nis: widget.data['nis'],
      nama: namaC.text,
      idClass: selectedKelas!,
      gender: genderC.text,
      tanggalLahir:
          tglC.text.isEmpty ? null : DateTime.tryParse(tglC.text),
      alamat: alamatC.text,
      orangTua: ortuC.text,
      noTele: int.tryParse(teleC.text),
    );

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Future<void> deleteData() async {
    await service.deleteMurid(widget.data['id_tabel']);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Widget field(String label, TextEditingController c) {
    if (!edit) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text("$label : ${c.text.isEmpty ? '-' : c.text}"),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget kelasField() {
    if (!edit) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          "Kelas : ${widget.data['class_name']?['name_class'] ?? '-'}",
        ),
      );
    }

    return DropdownButtonFormField<int>(
      value: selectedKelas,
      decoration: const InputDecoration(labelText: "Kelas"),
      items: kelasList.map((e) {
        return DropdownMenuItem<int>(
          value: e['id_class'],
          child: Text(e['name_class']),
        );
      }).toList(),
      onChanged: (v) => setState(() => selectedKelas = v),
    );
  }

  @override
  void dispose() {
    namaC.dispose();
    genderC.dispose();
    tglC.dispose();
    alamatC.dispose();
    ortuC.dispose();
    teleC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Murid"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("NIS : ${widget.data['nis']}"),
            const SizedBox(height: 12),

            field("Nama", namaC),
            field("Gender", genderC),
            field("Tanggal Lahir", tglC),
            kelasField(),
            const SizedBox(height: 12),
            field("Alamat", alamatC),
            field("Orang Tua", ortuC),
            field("No Telepon", teleC),

            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (edit) {
                        updateData();
                      } else {
                        setState(() => edit = true);
                      }
                    },
                    child: Text(edit ? "Simpan" : "Edit"),
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          edit ? Colors.grey : Colors.red,
                    ),
                    onPressed: () {
                      if (edit) {
                        setState(() => edit = false);
                      } else {
                        deleteData();
                      }
                    },
                    child: Text(edit ? "Batal" : "Delete"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}