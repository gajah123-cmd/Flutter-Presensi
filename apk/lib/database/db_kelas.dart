import 'package:supabase_flutter/supabase_flutter.dart';

class ClassService {

  static final supabase = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> getClasses() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await supabase
          .from('class_name')
          .select('*, guru!guru_id_class_fkey(name, wali)')
          .eq('user_id', userId)
          .order('id_class');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error fetching with relations: $e");
      
      // Fallback if the relationship queries throw error (e.g. FK not yet reflected)
      try {
        final response2 = await supabase
            .from('class_name')
            .select('*')
            .eq('user_id', userId)
            .order('id_class');
        return List<Map<String, dynamic>>.from(response2);
      } catch (eFallback) {
         print("Fallback fetching failed: $eFallback");
         return [];
      }
    }
  }

  static Future<List<Map<String, dynamic>>> getGuru() async {
    final response = await supabase
        .from('guru')
        .select('id_tabel, name')
        .order('name');
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<List<Map<String, dynamic>>> getMurid() async {
    final response = await supabase
        .from('murid')
        .select('id_tabel, nama')
        .order('nama');
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<List<Map<String, dynamic>>> getMuridByClass(String idTabelClass) async {
    final response = await supabase
        .from('murid')
        .select('id_tabel, nis, nama, gender')
        .eq('id_class', idTabelClass)
        .order('nama');
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<List<Map<String, dynamic>>> getGuruByClass(String idTabelClass) async {
    final response = await supabase
        .from('guru')
        .select('id_tabel, nik, name, bidang, wali')
        .eq('id_class', idTabelClass)
        .order('wali', ascending: false); // Wali kelas will be at the top
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> tambahKelas({
    required num idClass,
    required String nameClass,
    String? idGuru,
    String? idMurid,
    String? tahun,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception("User not logged in");

    await supabase.from('class_name').insert({
      'id_class': idClass,
      'name_class': nameClass,
      'user_id': userId,
      if (idGuru != null) 'id_guru': idGuru,
      if (idMurid != null) 'id_murid': idMurid,
      if (tahun != null) 'tahun': tahun,
    });
  }
}
