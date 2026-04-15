import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FormSiswaPage extends StatefulWidget {
  const FormSiswaPage({super.key});

  @override
  State<FormSiswaPage> createState() => _FormSiswaPageState();
}

class _FormSiswaPageState extends State<FormSiswaPage> {
  final supabase = Supabase.instance.client;

  final _formKey = GlobalKey<FormState>();

  bool isSubmitted = false;

  final nisController = TextEditingController();
  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final orangTuaController = TextEditingController();
  final noTeleController = TextEditingController();

  String? gender;
  DateTime? tanggalLahir;
  int? selectedClassId;

  List<dynamic> classList = [];

  @override
  void initState() {
    super.initState();
    fetchClass();
  }

  Future<void> fetchClass() async {
    try {
      final data = await supabase.from('class_name').select();

      setState(() {
        classList = data;
      });
    } catch (e) {
      debugPrint("Error fetch class: $e");
    }
  }

  Future<void> submitData() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await supabase.from('murid').insert({
        'nis': int.tryParse(nisController.text) ?? 0,
        'nama': namaController.text,
        'gender': gender,
        'tanggal_lahir': tanggalLahir?.toIso8601String(),
        'alamat': alamatController.text,
        'orang_tua': orangTuaController.text,
        'no_tele': int.tryParse(noTeleController.text),
        'id_class': selectedClassId,
      });

      setState(() {
        isSubmitted = true;
      });
    } catch (e) {
      debugPrint("Insert error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan data")),
      );
    }
  }

  @override
  void dispose() {
    nisController.dispose();
    namaController.dispose();
    alamatController.dispose();
    orangTuaController.dispose();
    noTeleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Container(
          width: 360,
          height: 640,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              // HEADER
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Tambah Data Murid",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: isSubmitted
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.green, size: 60),
                              const SizedBox(height: 10),
                              const Text("Berhasil disimpan"),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isSubmitted = false;
                                  });
                                },
                                child: const Text("Tambah Lagi"),
                              )
                            ],
                          ),
                        )
                      : Form(
                          key: _formKey,
                          child: ListView(
                            children: [

                              // NIS
                              TextFormField(
                                controller: nisController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: "NIS"),
                                validator: (v) =>
                                    (v == null || v.isEmpty) ? "Wajib diisi" : null,
                              ),

                              // NAMA
                              TextFormField(
                                controller: namaController,
                                decoration: const InputDecoration(labelText: "Nama Lengkap"),
                              ),

                              // GENDER
                              DropdownButtonFormField<String>(
                                value: gender,
                                hint: const Text("Jenis Kelamin"),
                                items: const [
                                  DropdownMenuItem(value: "L", child: Text("Laki-laki")),
                                  DropdownMenuItem(value: "P", child: Text("Perempuan")),
                                ],
                                onChanged: (v) => setState(() => gender = v),
                              ),

                              // TANGGAL LAHIR
                              ListTile(
                                title: Text(
                                  tanggalLahir == null
                                      ? "Pilih Tanggal Lahir"
                                      : "${tanggalLahir!.day}-${tanggalLahir!.month}-${tanggalLahir!.year}",
                                ),
                                trailing: const Icon(Icons.calendar_today),
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1990),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      tanggalLahir = picked;
                                    });
                                  }
                                },
                              ),

                              // ALAMAT
                              TextFormField(
                                controller: alamatController,
                                decoration: const InputDecoration(labelText: "Alamat"),
                              ),

                              // ORANG TUA
                              TextFormField(
                                controller: orangTuaController,
                                decoration: const InputDecoration(labelText: "Orang Tua"),
                              ),

                              // NO TELEPON
                              TextFormField(
                                controller: noTeleController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(labelText: "No Telepon"),
                              ),

                              const SizedBox(height: 10),

                              // CLASS DROPDOWN (FIX NULL SAFETY)
                              DropdownButtonFormField<int>(
                                value: selectedClassId,
                                hint: const Text("Pilih Kelas"),
                                items: classList.map((e) {
                                  final id = e['id_class'];
                                  final name = e['nama_class'] ?? '-';

                                  return DropdownMenuItem<int>(
                                    value: id,
                                    child: Text(name.toString()),
                                  );
                                }).toList(),
                                onChanged: (v) =>
                                    setState(() => selectedClassId = v),
                              ),

                              const SizedBox(height: 20),

                              ElevatedButton(
                                onPressed: submitData,
                                child: const Text("Simpan"),
                              )
                            ],
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}