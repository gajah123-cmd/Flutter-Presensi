import 'package:flutter/material.dart';
import 'package:apk/database/db_siswa.dart';
import 'package:apk/function/custom_button.dart';

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
  bool isSaving = false;

  late TextEditingController nisC;
  late TextEditingController namaC;
  late TextEditingController genderC;
  late TextEditingController tglC;
  late TextEditingController alamatC;
  late TextEditingController ortuC;
  late TextEditingController teleC;

  List<Map<String, dynamic>> kelasList = [];
  String? selectedKelas;

  @override
  void initState() {
    super.initState();

    nisC = TextEditingController(text: widget.data['nis']?.toString() ?? "");
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
    setState(() => isSaving = true);

    try {
      await service.updateMurid(
        idTabel: widget.data['id_tabel'],
        nis: num.tryParse(nisC.text) ?? 0,
        nama: namaC.text,
        idClass: selectedKelas,
        gender: genderC.text,
        tanggalLahir: tglC.text.isEmpty ? null : DateTime.tryParse(tglC.text),
        alamat: alamatC.text,
        orangTua: ortuC.text,
        noTele: num.tryParse(teleC.text),
      );

      final selectedKelasData = kelasList.where(
        (kelas) => kelas['id_tabel'] == selectedKelas,
      );

      if (mounted) {
        setState(() {
          widget.data['nis'] = num.tryParse(nisC.text) ?? 0;
          widget.data['nama'] = namaC.text;
          widget.data['id_class'] = selectedKelas;
          widget.data['gender'] = genderC.text;
          widget.data['tanggal_lahir'] = tglC.text;
          widget.data['alamat'] = alamatC.text;
          widget.data['orang_tua'] = ortuC.text;
          widget.data['no_tele'] = num.tryParse(teleC.text);
          widget.data['class_name'] = selectedKelasData.isEmpty
              ? null
              : {
                  'id_tabel': selectedKelasData.first['id_tabel'],
                  'name_class': selectedKelasData.first['name_class'],
                };
          edit = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data murid berhasil diperbarui')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  Future<void> deleteData() async {
    await service.deleteMurid(widget.data['id_tabel']);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Widget field(String label, TextEditingController c, {String hint = ""}) {
    if (!edit) {
      return _infoCard(
        icon: _iconForLabel(label),
        title: label,
        value: _displayValue(label, c.text),
        isEmpty: c.text.isEmpty,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          style: const TextStyle(fontFamily: 'Inter'),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFC4C4C4), fontFamily: 'Inter'),
            filled: true,
            fillColor: const Color(0xFFF1F5F9),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget kelasField() {
    if (!edit) {
      final kelas = widget.data['class_name']?['name_class']?.toString() ?? "";
      return _infoCard(
        icon: Icons.school_outlined,
        title: "Kelas",
        value: kelas.isEmpty ? "Belum diisi" : kelas,
        isEmpty: kelas.isEmpty,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Kelas",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: selectedKelas,
          decoration: InputDecoration(
            hintText: "Pilih Kelas",
            hintStyle: const TextStyle(color: Color(0xFFC4C4C4), fontFamily: 'Inter'),
            filled: true,
            fillColor: const Color(0xFFF1F5F9),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
          items: kelasList.map((e) {
            return DropdownMenuItem<String>(
              value: e['id_tabel'],
              child: Text(e['name_class'], style: const TextStyle(fontFamily: 'Inter')),
            );
          }).toList(),
          onChanged: (v) => setState(() => selectedKelas = v),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget genderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gender",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: genderC.text.isEmpty ? null : genderC.text,
          decoration: InputDecoration(
            hintText: "Pilih Gender",
            hintStyle: const TextStyle(color: Color(0xFFC4C4C4), fontFamily: 'Inter'),
            filled: true,
            fillColor: const Color(0xFFF1F5F9),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
          items: const [
            DropdownMenuItem(value: "L", child: Text("L", style: TextStyle(fontFamily: 'Inter'))),
            DropdownMenuItem(value: "P", child: Text("P", style: TextStyle(fontFamily: 'Inter'))),
          ],
          onChanged: (v) => setState(() => genderC.text = v ?? ""),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  IconData _iconForLabel(String label) {
    switch (label) {
      case "NIS":
        return Icons.badge_outlined;
      case "Nama":
        return Icons.person_outline;
      case "Gender":
        return Icons.person_pin_outlined;
      case "Tanggal Lahir":
        return Icons.calendar_month_outlined;
      case "Alamat":
        return Icons.location_on_outlined;
      case "Orang Tua":
        return Icons.groups_2_outlined;
      case "No Telepon":
        return Icons.phone_outlined;
      default:
        return Icons.info_outline;
    }
  }

  String get _nama => namaC.text.isEmpty ? "Belum diisi" : namaC.text;
  String get _nis => nisC.text.isEmpty ? "Belum diisi" : nisC.text;
  String get _kelas {
    final kelas = widget.data['class_name']?['name_class']?.toString() ?? "";
    return kelas.isEmpty ? "Belum ada kelas" : kelas;
  }

  String _displayValue(String label, String value) {
    if (value.isEmpty) return "Belum diisi";
    if (label != "Tanggal Lahir") return value;

    final date = DateTime.tryParse(value);
    if (date == null) return value;

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return "$day-$month-${date.year}";
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    bool isEmpty = false,
  }) {
    return CustomCard(
      title: title,
      subtitle: value,
      icon: icon,
      iconPosition: IconPosition.left,
      iconColor: const Color(0xFF2563EB),
      iconSize: 24,
      iconContainerSize: 46,
      iconDecoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(9),
      ),
      backgroundColor: Colors.white,
      borderColor: Colors.transparent,
      borderWidth: 0,
      borderRadius: 0,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      boxShadow: const [],
      titleStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF8FA0BA),
      ),
      subtitleStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
        color: isEmpty ? const Color(0xFFC8D2E0) : const Color(0xFF172033),
      ),
      showIcon: true,
    );
  }

  Widget _sectionCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EEF6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              children[i],
              if (i != children.length - 1)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F4FA),
                  indent: 82,
                  endIndent: 20,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _profileHeader() {
    return SizedBox(
      height: 128,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomCard(
            title: "",
            showIcon: false,
            height: 126,
            backgroundColor: Colors.white,
            borderColor: const Color(0xFFE8EEF6),
            borderWidth: 1,
            borderRadius: 18,
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.13),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _nama,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF172033),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.badge_outlined,
                    size: 18,
                    color: Color(0xFF8FA0BA),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "NIS: $_nis",
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.school_outlined,
                      size: 18,
                      color: Color(0xFF2563EB),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _kelas,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required Color color,
    required VoidCallback? onPressed,
    bool loading = false,
  }) {
    final bool isWhite = color == Colors.white;
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: isWhite ? const Color(0xFF64748B) : Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: isWhite ? const BorderSide(color: Color(0xFF94A3B8)) : BorderSide.none,
          ),
        ),
        child: loading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: isWhite ? const Color(0xFF64748B) : Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  Widget _editBody() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Row(
                  children: const [
                    Text("📋", style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text(
                      "Data Utama",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      field("NIS *", nisC, hint: "Contoh: 332817"),
                      field("Nama *", namaC, hint: "Contoh: Budi Santoso"),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: genderField()),
                          const SizedBox(width: 16),
                          Expanded(child: field("Tanggal Lahir", tglC, hint: "YYYY-MM-DD")),
                        ],
                      ),
                      kelasField(),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Row(
                  children: const [
                    Text("📚", style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text(
                      "Kontak & Orang Tua",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      field("Alamat", alamatC, hint: "Masukkan alamat"),
                      field("Orang Tua", ortuC, hint: "Nama orang tua"),
                      field("No Telepon", teleC, hint: "Nomor telepon"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _actionButton(
                label: "Simpan",
                color: const Color(0xFF2563EB),
                onPressed: isSaving ? null : updateData,
                loading: isSaving,
              ),
              const SizedBox(width: 10),
              _actionButton(
                label: "Batal",
                color: Colors.white,
                onPressed: isSaving ? null : () => setState(() => edit = false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nisC.dispose();
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
    if (edit) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Edit Data Murid", style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1E293B),
          elevation: 0,
        ),
        body: _editBody(),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text("Detail Murid"),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
        children: [
          _profileHeader(),
          const SizedBox(height: 20),
          _sectionTitle("Identitas"),
          _sectionCard([
            field("Gender", genderC),
            field("Tanggal Lahir", tglC),
            field("Alamat", alamatC),
          ]),
          const SizedBox(height: 18),
          _sectionTitle("Kontak Orang Tua"),
          _sectionCard([
            field("Orang Tua", ortuC),
            field("No Telepon", teleC),
          ]),
          const SizedBox(height: 24),
          Row(
            children: [
              _actionButton(
                label: "Edit",
                color: const Color(0xFF2563EB),
                onPressed: () => setState(() => edit = true),
              ),
              const SizedBox(width: 10),
              _actionButton(
                label: "Delete",
                color: Colors.red,
                onPressed: deleteData,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
