import 'package:flutter/material.dart';
import 'package:apk/database/db_guru.dart';

class DetailGuruPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const DetailGuruPage({
    super.key,
    required this.data,
  });

  @override
  State<DetailGuruPage> createState() => _DetailGuruPageState();
}

class _DetailGuruPageState extends State<DetailGuruPage> {
  final service = GuruService();

  bool edit = false;
  bool isLoading = false;

  late TextEditingController nikC;
  late TextEditingController nameC;
  late TextEditingController bidangC;

  List<Map<String, dynamic>> kelasList = [];
  String? selectedKelas;
  late bool isWali;

  @override
  void initState() {
    super.initState();

    nikC = TextEditingController(text: widget.data['nik']?.toString() ?? "");
    nameC = TextEditingController(text: widget.data['name'] ?? "");
    bidangC = TextEditingController(text: widget.data['bidang'] ?? "");

    selectedKelas = widget.data['id_class'];
    isWali = widget.data['wali'] == true;

    loadKelas();
  }

  Future<void> loadKelas() async {
    final data = await GuruService.getKelas();
    if (mounted) {
      setState(() => kelasList = data);
    }
  }

  Future<void> updateData() async {
    if (nikC.text.isEmpty || nameC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("NIK dan Nama wajib diisi!")),
      );
      return;
    }

    if (isWali && selectedKelas == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kelas wajib dipilih jika menjadi Wali Kelas!")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await GuruService.updateGuru(
        idTabel: widget.data['id_tabel'],
        nik: num.parse(nikC.text),
        name: nameC.text,
        bidang: bidangC.text.isEmpty ? null : bidangC.text,
        idClass: selectedKelas,
        wali: isWali,
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteData() async {
    setState(() => isLoading = true);
    try {
      await GuruService.deleteGuru(widget.data['id_tabel']);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
      setState(() => isLoading = false);
    }
  }

  Widget field(String label, TextEditingController c, {TextInputType? keyboardType}) {
    if (!edit) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text("$label : ${c.text.isEmpty ? '-' : c.text}", style: const TextStyle(fontSize: 16)),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget kelasField() {
    if (!edit) {
      final className = widget.data['class_name']?['name_class'] ?? '-';
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          "Kelas : $className",
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: selectedKelas,
        decoration: InputDecoration(
          labelText: "Pilih Kelas",
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        items: kelasList.map((e) {
          return DropdownMenuItem<String>(
            value: e['id_tabel'],
            child: Text(e['name_class']),
          );
        }).toList(),
        onChanged: (v) => setState(() => selectedKelas = v),
      ),
    );
  }

  Widget waliField() {
    if (!edit) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          "Wali Kelas : ${isWali ? 'Ya' : 'Tidak'}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Wali Kelas", style: TextStyle(fontSize: 16)),
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
    );
  }

  @override
  void dispose() {
    nikC.dispose();
    nameC.dispose();
    bidangC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Guru"),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                field("NIK", nikC, keyboardType: TextInputType.number),
                field("Nama Lengkap", nameC),
                field("Bidang", bidangC),
                waliField(),
                if (edit || selectedKelas != null) kelasField(),

                const Spacer(),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                if (edit) {
                                  updateData();
                                } else {
                                  setState(() => edit = true);
                                }
                              },
                        child: Text(edit ? "Simpan" : "Edit", style: const TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: edit ? Colors.grey[400] : Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                if (edit) {
                                  // Revert changes
                                  setState(() {
                                    edit = false;
                                    nikC.text = widget.data['nik']?.toString() ?? "";
                                    nameC.text = widget.data['name'] ?? "";
                                    bidangC.text = widget.data['bidang'] ?? "";
                                    selectedKelas = widget.data['id_class'];
                                    isWali = widget.data['wali'] == true;
                                  });
                                } else {
                                  deleteData();
                                }
                              },
                        child: Text(edit ? "Batal" : "Hapus", style: const TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
