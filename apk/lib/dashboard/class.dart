import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:apk/function/custom_button.dart';
import 'package:apk/database/db_kelas.dart';
import 'package:apk/function/f_kelas/content_kelas.dart';

class DaftarKelas extends StatefulWidget {
  const DaftarKelas({super.key});

  @override
  State<DaftarKelas> createState() => _DaftarKelasState();
}

class _DaftarKelasState extends State<DaftarKelas> {
  final List<int> kelasList = [1, 2, 3, 4, 5, 6];
  List<Map<String, dynamic>> allData = [];
  int? expandedId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final res = await ClassService.getClasses();
      setState(() {
        allData = res;
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) print(e);
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pengaman jika allData somehow null
    final dataCount = allData.length;

    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            color: const Color(0xFF2563EB),
            height: 45,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Daftar Kelas",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "$dataCount kelas terdaftar",
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      fetchData();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF2563EB),
        automaticallyImplyLeading: false,
      ),

      body: Column(
        children: [
          Container(
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  onChanged: (value) {
                    if (kDebugMode) {
                      print("Search: $value");
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Cari kelas atau wali kelas...",
                    hintStyle: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFCCCCCC),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    itemCount: kelasList.length + 1,
                    itemBuilder: (context, index) {
                      final isLainLain = index == kelasList.length;
                      final id = isLainLain ? 7 : kelasList[index];
                      final title = isLainLain ? 'Lain-lain' : 'Kelas $id';
                      
                      // Sangat preventif
                      final List<Map<String, dynamic>> thisLevelClasses = allData.where((e) {
                        return e['id_class'] == id;
                      }).toList();

                      return Column(
                        children: [
                          CustomCard(
                            title: title,
                            borderColor: const Color(0xFFDBEAFE),
                            backgroundColor: const Color(0xFFEFF6FF),
                            height: 95,
                            width: double.maxFinite,
                            alignment: Alignment.center,
                            onTap: () {
                              setState(() {
                                expandedId = expandedId == id ? null : id;
                              });
                            },
                          ),
                          if (expandedId == id && thisLevelClasses.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text("Belum ada kelas di tingkat ini", style: TextStyle(color: Colors.grey)),
                            ),
                          if (expandedId == id && thisLevelClasses.isNotEmpty)
                            ...thisLevelClasses.map((item) {
                              final nameClass = item['name_class']?.toString() ?? 'Tanpa Nama';
                              
                              String guruName = '-';
                              if (item['guru'] is List) {
                                final List gurus = item['guru'] as List;
                                final waliGuru = gurus.firstWhere((g) => g['wali'] == true, orElse: () => null);
                                if (waliGuru != null) {
                                  guruName = waliGuru['name']?.toString() ?? '-';
                                }
                              }

                              final tahun = item['tahun']?.toString() ?? '-';

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  child: ListTile(
                                    title: Text(nameClass, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text("Wali: $guruName | Tahun: $tahun"),
                                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ContentKelas(classData: item),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}