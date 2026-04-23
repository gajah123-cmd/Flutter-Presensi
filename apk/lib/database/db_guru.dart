import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GuruService {
  static final supabase = Supabase.instance.client;

  static String get userId {
    final id = supabase.auth.currentUser?.id;
    if (id == null) {
      throw Exception('User belum login');
    }
    return id;
  }

  // ===============================
  // 🔹 GET DATA GURU
  // ===============================
  static Future<List<Map<String, dynamic>>> getGuru() async {
    try {
      final response = await supabase
          .from('guru')
          .select('''
            id_tabel,
            nik,
            name,
            bidang,
            wali,
            id_class,
            created_at,
            class_name!guru_id_class_fkey (
              id_tabel,
              name_class
            )
          ''')
          .eq('user_id', userId)
          .order('name', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) {
        print('GET GURU ERROR: $e');
      }
      throw Exception('Gagal memuat data guru: $e');
    }
  }

  // ===============================
  // 🔹 GET DATA KELAS
  // ===============================
  static Future<List<Map<String, dynamic>>> getKelas() async {
    try {
      final response = await supabase
          .from('class_name')
          .select('id_tabel, name_class')
          .order('name_class');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) {
        print('GET KELAS ERROR: $e');
      }
      return [];
    }
  }

  // ===============================
  // 🔹 CHECK WALI KELAS
  // ===============================
  static Future<bool> checkWaliExists(String idClass, {String? excludeGuruId}) async {
    try {
      var query = supabase
          .from('guru')
          .select('id_tabel')
          .eq('user_id', userId)
          .eq('id_class', idClass)
          .eq('wali', true);

      if (excludeGuruId != null) {
        query = query.neq('id_tabel', excludeGuruId);
      }

      final res = await query.limit(1);
      return res.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('CHECK WALI ERROR: $e');
      }
      throw Exception('Gagal mengecek status wali kelas');
    }
  }

  // ===============================
  // 🔹 INSERT DATA GURU
  // ===============================
  static Future<void> tambahGuru({
    required num nik,
    required String name,
    String? bidang,
    String? idClass,
    required bool wali,
  }) async {
    try {
      if (wali && idClass == null) {
        throw Exception('Kelas harus dipilih jika menjadi Wali Kelas');
      }

      if (wali && idClass != null) {
        final exists = await checkWaliExists(idClass);
        if (exists) {
          throw Exception('Kelas ini sudah memiliki wali kelas!');
        }
      }

      await supabase.from('guru').insert({
        'user_id': userId,
        'nik': nik,
        'name': name,
        'bidang': bidang,
        'id_class': idClass,
        'wali': wali,
      });
    } catch (e) {
      if (kDebugMode) {
        print('ADD GURU ERROR: $e');
      }
      rethrow;
    }
  }

  // ===============================
  // 🔹 UPDATE DATA GURU
  // ===============================
  static Future<void> updateGuru({
    required String idTabel,
    required num nik,
    required String name,
    String? bidang,
    String? idClass,
    required bool wali,
  }) async {
    try {
      if (wali && idClass == null) {
        throw Exception('Kelas harus dipilih jika menjadi Wali Kelas');
      }

      if (wali && idClass != null) {
        final exists = await checkWaliExists(idClass, excludeGuruId: idTabel);
        if (exists) {
          throw Exception('Kelas ini sudah memiliki wali kelas!');
        }
      }

      await supabase.from('guru').update({
        'nik': nik,
        'name': name,
        'bidang': bidang,
        'id_class': idClass,
        'wali': wali,
      }).eq('id_tabel', idTabel).eq('user_id', userId);
    } catch (e) {
      if (kDebugMode) {
        print('UPDATE GURU ERROR: $e');
      }
      rethrow;
    }
  }

  // ===============================
  // 🔹 DELETE DATA GURU
  // ===============================
  static Future<void> deleteGuru(String idTabel) async {
    try {
      await supabase.from('guru').delete().eq('id_tabel', idTabel).eq('user_id', userId);
    } catch (e) {
      if (kDebugMode) {
        print('DELETE GURU ERROR: $e');
      }
      rethrow;
    }
  }
}