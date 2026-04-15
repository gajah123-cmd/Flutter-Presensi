// import 'package:apk/funtion/daftar_murid.dart';
import 'package:apk/function/f_murid/form_murid.dart';
import 'package:flutter/material.dart';
//import 'package:apk/function/bottom_nav.dart';
import 'package:apk/function/custom_button.dart';

class TambahPengguna extends StatefulWidget {
  const TambahPengguna({super.key});

  @override
  State<TambahPengguna> createState() => _TambahPenggunaState();
}

class _TambahPenggunaState extends State<TambahPengguna> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: const BottomNav(selectedIndex: 2),
      appBar: AppBar(
        title: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tambah Pengguna",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF2563EB),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  CustomCard(
                  width: 350,
                  height: 95,
                  title: "Tambahkan Akun Murid",
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 255, 255, 255),
                      Colors.lightBlueAccent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderColor: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: const Color.fromARGB(255, 3, 3, 3).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  titleStyle: const TextStyle(
                    fontFamily: "Inter",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                   customIcon: Image.asset('lib/asset/icons/b_people.png',
                        width: 35,
                        height: 35,
                       ),
                       iconDecoration: BoxDecoration(
                        color: Colors.lightBlueAccent[100],
                        borderRadius: BorderRadius.circular(12),
                       ),
                       iconPosition: IconPosition.left,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FormSiswaPage()),
                    );                   
                  },
                ),
                CustomCard(
                  width: 350,
                  height: 95,
                  title: "Tambahkan Akun Guru",
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 255, 255, 255),
                      Colors.greenAccent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderColor: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: const Color.fromARGB(255, 3, 3, 3).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  titleStyle: const TextStyle(
                    fontFamily: "Inter",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                   customIcon: Image.asset('lib/asset/icons/h_hat.png',
                        width: 35,
                        height: 35,
                       ),
                       iconDecoration: BoxDecoration(
                        color: Colors.greenAccent[100],
                        borderRadius: BorderRadius.circular(12),
                       ),
                        iconPosition: IconPosition.left,
                  onTap: () {},
                ),
                CustomCard(
                  width: 350,
                  height: 95,
                  title: "Tambahkan Kelas",
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 255, 255, 255),
                      Colors.orangeAccent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderColor: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: const Color.fromARGB(255, 3, 3, 3).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  titleStyle: const TextStyle(
                    fontFamily: "Inter",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                   customIcon: Image.asset('lib/asset/icons/menu.png',
                        width: 35,
                        height: 35,
                       ),
                        iconDecoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                       iconPosition: IconPosition.left,
                  onTap: () {},
                ),

                const SizedBox(height: 30),

                const Divider(
                  thickness: 0.8,
                  color: Colors.black26,
                  indent: 10,
                  endIndent: 10,
                ),

                const SizedBox(height: 15),

                  CustomCard(
                    width: 180,
                    height: 60,
                    title: "Daftar Murid",
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 7,),
                    borderColor: Colors.lightBlue,
                    titleStyle: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 56, 59, 238),
                    ),
                    customIcon: Image.asset('lib/asset/icons/a_note.png',
                          width: 40,
                          height: 40,
                        ),
                        iconPosition: IconPosition.left,
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const DaftarMurid()),
                      // );
                    },
                  ),
                   CustomCard(
                    width: 180,
                    height: 60,
                    title: "Daftar Guru",
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 7,),
                    borderColor: Colors.lightBlue,
                    titleStyle: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 56, 59, 238),
                    ),
                    customIcon: Image.asset('lib/asset/icons/a_note.png',
                          width: 40,
                          height: 40,
                        ),
                        iconPosition: IconPosition.left,
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const DaftarMurid()),
                      // );
                    },
                  ),                    
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }
}