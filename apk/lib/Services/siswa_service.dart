import 'package:supabase_flutter/supabase_flutter.dart';

class SiswaService {

  static Future<void> tambahSiswa({
    required int nis,
    required String name,
    required String tglLahir,
    required String gender,
    required String address,
    required int noTlp,
    required String status,
  }) async {

    final client = Supabase.instance.client;

    await client.from('id_siswa').insert({
      'nis': nis,
      'name': name,
      'tgl_lahir': tglLahir,
      'gender': gender,
      'address': address,
      'no_tlp_ort': noTlp,
      'status': status,
    });

    await client.from('daftar_siswa').insert({
      'id_siswa': nis,
    });
  }

  static Future<List<Map<String, dynamic>>> getDaftarSiswa() async {

    final response = await Supabase.instance.client
        .from('daftar_siswa')
        .select('''
          id_siswa,
          update,
          id_siswa (
            nis,
            name,
            tgl_lahir,
            gender,
            address,
            no_tlp_ort,
            status
          )
        ''');

    return List<Map<String, dynamic>>.from(response);
  }
}