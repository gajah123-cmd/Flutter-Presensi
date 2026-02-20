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

    await Supabase.instance.client
        .from('id_siswa')
        .insert({
          'nis': nis,
          'name': name,
          'tgl_lahir': tglLahir,
          'gender': gender,
          'address': address,
          'no_tlp_ort': noTlp,
          'status': status,
        });
  }
}
