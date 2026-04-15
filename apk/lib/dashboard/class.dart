import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
//import 'package:apk/function/bottom_nav.dart';
import 'package:apk/function/custom_button.dart';

class DaftarKelas extends StatefulWidget {
  const DaftarKelas({super.key});

  @override
  State<DaftarKelas> createState() => _DaftarKelasState();
}

class _DaftarKelasState extends State<DaftarKelas> {

  final List<int> kelasList = [1, 2, 3, 4, 5, 6];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // bottomNavigationBar: const BottomNav(selectedIndex: 0),
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            color: const Color(0xFF2563EB),
            height: 45,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //const SizedBox(height: 8),
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
               const SizedBox(height: 6),
               const Padding(
                 padding: EdgeInsets.symmetric(horizontal: 20),
                 child: Text(
                   "6 kelas terdaftar",
                   style: TextStyle(
                    fontFamily: 'Inter',
                     fontSize: 10.5,
                     fontWeight: FontWeight.w400,
                     color: Colors.white70,
                   ),
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

          SizedBox(height: 8),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              itemCount: kelasList.length,
              itemBuilder: (context, index) {
                final id = kelasList[index];

                return CustomCard(
                  title: 'Kelas $id',
                  borderColor: const Color(0xFFDBEAFE),
                  backgroundColor: const Color(0xFFEFF6FF),
                  height: 95,
                  width: double.maxFinite,
                  alignment: AlignmentGeometry.center,
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}