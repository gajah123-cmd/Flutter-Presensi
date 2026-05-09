import 'package:flutter/material.dart';
import 'package:apk/database/db_guru.dart';
import 'package:apk/function/custom_button.dart';

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
  bool edit = false;
  bool isSaving = false;

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
        const SnackBar(
          content: Text("Kelas wajib dipilih jika menjadi Wali Kelas!"),
        ),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      await GuruService.updateGuru(
        idTabel: widget.data['id_tabel'],
        nik: num.tryParse(nikC.text) ?? 0,
        name: nameC.text,
        bidang: bidangC.text.isEmpty ? null : bidangC.text,
        idClass: selectedKelas,
        wali: isWali,
      );

      final selectedKelasData = kelasList.where(
        (kelas) => kelas['id_tabel'] == selectedKelas,
      );

      if (mounted) {
        setState(() {
          widget.data['nik'] = num.tryParse(nikC.text) ?? 0;
          widget.data['name'] = nameC.text;
          widget.data['bidang'] = bidangC.text;
          widget.data['id_class'] = selectedKelas;
          widget.data['wali'] = isWali;
          widget.data['class_name'] = selectedKelasData.isEmpty
              ? null
              : {
                  'id_tabel': selectedKelasData.first['id_tabel'],
                  'name_class': selectedKelasData.first['name_class'],
                };
          edit = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data guru berhasil diperbarui')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Gagal menyimpan: ${e.toString().replaceAll('Exception: ', '')}",
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  Future<void> deleteData() async {
    try {
      await GuruService.deleteGuru(widget.data['id_tabel']);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    }
  }

  Widget field(
    String label,
    TextEditingController c, {
    TextInputType? keyboardType,
    String hint = "",
  }) {
    if (!edit) {
      return _infoCard(
        icon: _iconForLabel(label),
        title: label,
        value: c.text.isEmpty ? "Belum diisi" : c.text,
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
          keyboardType: keyboardType,
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

  Widget waliField() {
    if (!edit) {
      return _infoCard(
        icon: Icons.verified_user_outlined,
        title: "Wali Kelas",
        value: isWali ? "Ya" : "Tidak",
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Wali Kelas",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Jadikan Wali Kelas",
                style: TextStyle(fontFamily: 'Inter', fontSize: 15, color: Color(0xFF1E293B)),
              ),
              Switch(
                value: isWali,
                activeColor: const Color(0xFF2563EB),
                onChanged: (val) => setState(() => isWali = val),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  IconData _iconForLabel(String label) {
    switch (label) {
      case "NIK":
        return Icons.badge_outlined;
      case "Nama":
        return Icons.person_outline;
      case "Bidang":
        return Icons.menu_book_outlined;
      default:
        return Icons.info_outline;
    }
  }

  String get _nama => nameC.text.isEmpty ? "Belum diisi" : nameC.text;
  String get _nik => nikC.text.isEmpty ? "Belum diisi" : nikC.text;
  String get _badge {
    final kelas = widget.data['class_name']?['name_class']?.toString() ?? "";
    if (isWali) {
      return kelas.isEmpty ? "Wali Kelas" : kelas;
    }
    return bidangC.text.isEmpty ? "Guru" : bidangC.text;
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
                    "NIK: $_nik",
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
                      _badge,
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

  void _cancelEdit() {
    setState(() {
      edit = false;
      nikC.text = widget.data['nik']?.toString() ?? "";
      nameC.text = widget.data['name'] ?? "";
      bidangC.text = widget.data['bidang'] ?? "";
      selectedKelas = widget.data['id_class'];
      isWali = widget.data['wali'] == true;
    });
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
                    Text("👩‍🏫", style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text(
                      "Data Guru",
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
                      field("NIK *", nikC, keyboardType: TextInputType.number, hint: "Contoh: 33111"),
                      field("Nama *", nameC, hint: "Contoh: Budi Santoso"),
                      field("Bidang", bidangC, hint: "Contoh: Matematika"),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: const [
                    Text("🏫", style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text(
                      "Wali Kelas & Kelas",
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
                      waliField(),
                      if (edit || selectedKelas != null) kelasField(),
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
                onPressed: isSaving ? null : _cancelEdit,
              ),
            ],
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
    if (edit) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Edit Data Guru", style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
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
        title: const Text("Detail Guru"),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
        children: [
          _profileHeader(),
          const SizedBox(height: 20),
          _sectionTitle("Identitas"),
          _sectionCard([
            field("Bidang", bidangC),
            waliField(),
            if (isWali || selectedKelas != null) kelasField(),
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
