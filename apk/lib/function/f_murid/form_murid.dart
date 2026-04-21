import 'package:flutter/material.dart';
import 'package:apk/database/db_siswa.dart';

class FormMuridPage extends StatefulWidget {
  const FormMuridPage({super.key});

  @override
  State<FormMuridPage> createState() => _FormMuridPageState();
}

class _FormMuridPageState extends State<FormMuridPage> {
  final MuridService service = MuridService();

  final nisController = TextEditingController();
  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final orangTuaController = TextEditingController();
  final noTeleController = TextEditingController();

  List<Map<String, dynamic>> kelasList = [];
  int? selectedClass;
  String? selectedGender;
  DateTime? selectedDate;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadKelas();
  }

  Future<void> loadKelas() async {
    final data = await service.getKelas();
    setState(() {
      kelasList = data;
    });
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2010),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> simpan() async {
    if (nisController.text.isEmpty ||
        namaController.text.isEmpty ||
        selectedClass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Field wajib belum diisi!")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await service.addMurid(
        nis: int.parse(nisController.text),
        nama: namaController.text,
        idClass: selectedClass!,
        gender: selectedGender,
        tanggalLahir: selectedDate,
        alamat: alamatController.text,
        orangTua: orangTuaController.text,
        noTele: int.tryParse(noTeleController.text),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data berhasil disimpan")),
      );

      // reset form
      nisController.clear();
      namaController.clear();
      alamatController.clear();
      orangTuaController.clear();
      noTeleController.clear();

      setState(() {
        selectedClass = null;
        selectedGender = null;
        selectedDate = null;
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
        leading: IconButton(
          icon: Image.asset('lib/asset/icons/Button.png',
           width: 30, height: 30),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: -5,
        title: const Text("Form Murid"),
        titleTextStyle: const TextStyle(
          fontFamily: "Inter",
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      
body: Padding(
  padding: const EdgeInsets.all(0),
  child: ListView(
    children: [

      // NIS
      const Text("NIS *"),
      const SizedBox(height: 6),
      TextField(
        controller: nisController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "Masukkan Nomor Induk Siswa",
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
          hintText: "Nama lengkap sesuai akta",
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

      // Gender
      const Text("Jenis Kelamin"),
      const SizedBox(height: 6),
      DropdownButtonFormField<String>(
        value: selectedGender,
        hint: const Text("Pilih Jenis Kelamin"),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        items: const [
          DropdownMenuItem(value: 'L', child: Text("Laki-laki")),
          DropdownMenuItem(value: 'P', child: Text("Perempuan")),
        ],
        onChanged: (value) {
          setState(() {
            selectedGender = value;
          });
        },
      ),

      const SizedBox(height: 16),

      // Tempat Lahir
      const Text("Tempat Lahir"),
      const SizedBox(height: 6),
      TextField(
        decoration: InputDecoration(
          hintText: "Kota/Kabupaten kelahiran",
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

      // Tanggal Lahir
      const Text("Tanggal Lahir"),
      const SizedBox(height: 6),
      InkWell(
        onTap: pickDate,
        child: InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedDate == null
                    ? "mm/dd/yyyy"
                    : selectedDate.toString().split(' ')[0],
                style: TextStyle(
                  color: selectedDate == null ? Colors.grey : Colors.black,
                ),
              ),
              const Icon(Icons.calendar_today, size: 18),
            ],
          ),
        ),
      ),

      const SizedBox(height: 16),

      // Kelas
      const Text("Kelas"),
      const SizedBox(height: 6),
      DropdownButtonFormField<int>(
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
          return DropdownMenuItem<int>(
            value: kelas['id_class'],
            child: Text(kelas['name_class']),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedClass = value;
          });
        },
      ),

      const SizedBox(height: 16),

      // Alamat
      const Text("Alamat"),
      const SizedBox(height: 6),
      TextField(
        controller: alamatController,
        decoration: InputDecoration(
          hintText: "Masukkan alamat",
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

      // Orang Tua
      const Text("Orang Tua"),
      const SizedBox(height: 6),
      TextField(
        controller: orangTuaController,
        decoration: InputDecoration(
          hintText: "Nama orang tua",
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

      // No HP
      const Text("No Telepon"),
      const SizedBox(height: 6),
      TextField(
        controller: noTeleController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "Masukkan nomor telepon",
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),

      const SizedBox(height: 24),

      ElevatedButton(
        onPressed: isLoading ? null : simpan,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Simpan"),
      ),
    ],
  ),
),
    );
  }
}