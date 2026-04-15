import 'package:supabase_flutter/supabase_flutter.dart';

class GuruService {
  static final supabase = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> getGuru() async {
    final response = await supabase
        .from('guru')
        .select('*, class_name(name_class)')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  static Future<List<Map<String, dynamic>>> getKelas() async {
    final response = await supabase
        .from('class_name')
        .select('id_class, name_class')
        .order('name_class');

    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> tambahGuru({
    required int nik,
    required String name,
    required String bidang,
    required int kelas, // ✅ int
    required bool hr,
  }) async {
    await supabase.from('guru').insert({
      'nik': nik,
      'name': name,
      'bidang': bidang,
      'class': kelas,
      'hr': hr,
    });
  }

  static Future<void> updateGuru({
    required int nik,
    required String name,
    required String bidang,
    required int kelas,
    required bool hr,
  }) async {
    await supabase.from('guru').update({
      'name': name,
      'bidang': bidang,
      'class': kelas,
      'hr': hr,
    }).eq('nik', nik);
  }

  static Future<void> deleteGuru(int nik) async {
    await supabase.from('guru').delete().eq('nik', nik);
  }
}