// import 'package:apk/funtion/daftar_murid.dart';
import 'package:apk/function/f_murid/form_murid.dart';
import 'package:flutter/material.dart';
//import 'package:apk/function/bottom_nav.dart';
import 'package:apk/function/custom_button.dart';
import 'package:apk/function/f_murid/get_murid.dart';
import 'package:apk/function/f_guru/form_guru.dart';
import 'package:apk/function/f_guru/get_guru.dart';
import 'package:apk/function/f_kelas/form_kelas..dart';
import 'package:apk/function/user_admin/profil.dart';
import 'package:apk/function/f_alat/form_alat.dart';

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
        titleSpacing: 20,
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                setState(() {});
              },
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: ListView(
                padding: EdgeInsets.zero,
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
                      MaterialPageRoute(builder: (context) => const FormMuridPage()),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FormGuruPage()),
                    );
                  },
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FormKelasPage()),
                    );
                  },
                ),

                const SizedBox(height: 30),

                const Divider(
                  thickness: 0.8,
                  color: Colors.black26,
                  indent: 10,
                  endIndent: 10,
                ),

                const SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            CustomCard(
                              width: 180,
                              height: 60,
                              margin: const EdgeInsets.only(bottom: 16),
                              title: "Daftar Murid",
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 7),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MuridPage()),
                                );
                              },
                            ),
                            CustomCard(
                              width: 180,
                              height: 60,
                              margin: const EdgeInsets.only(bottom: 16),
                              title: "Daftar Guru",
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 7),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const GuruPage()),
                                );
                              },
                            ),
                            CustomCard(
                              width: 180,
                              height: 60,
                              margin: EdgeInsets.zero,
                              title: "Profil Admin",
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 7),
                              borderColor: Colors.lightBlue,
                              titleStyle: const TextStyle(
                                fontFamily: "Inter",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 56, 59, 238),
                              ),
                              customIcon: const Icon(Icons.manage_accounts, color: Color(0xFF2563EB), size: 36),
                              iconPosition: IconPosition.left,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ProfilScreen()),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        CustomCard(
                          width: 154,
                          height: 212,
                          margin: EdgeInsets.zero,
                          title: "Daftar Alat\n\nTerhubung\n\nAktif",
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          borderColor: Colors.lightBlue,
                          titleStyle: const TextStyle(
                            fontFamily: "Inter",
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 56, 59, 238),
                          ),
                          showIcon: false,
                          titleAlign: TextAlign.left,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FormAlatPage()),
                            );
                          },
                        ),
                      ],
                    ),
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