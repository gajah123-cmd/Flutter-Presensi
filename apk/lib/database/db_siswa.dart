import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MuridService {
  final supabase = Supabase.instance.client;

  String get userId {
    final id = supabase.auth.currentUser?.id;
    if (id == null) {
      throw Exception('User belum login');
    }
    return id;
  }

  // ===============================
  // 🔹 GET DATA MURID
  // ===============================
  Future<List<Map<String, dynamic>>> getMurid() async {
    try {
      final res = await supabase
          .from('murid')
          .select('''
            id_tabel,
            nis,
            nama,
            id_class,
            gender,
            tanggal_lahir,
            alamat,
            orang_tua,
            no_tele,
            created_at,
            class_name (
              id_class,
              name_class
            )
          ''')
          .eq('user_id', userId)
          .order('nis', ascending: true);

      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      if (kDebugMode) {
        print('GET MURID ERROR: $e');
      }
      return [];
    }
  }

  // ===============================
  // 🔹 GET DATA KELAS
  // ===============================
  Future<List<Map<String, dynamic>>> getKelas() async {
    try {
      final res = await supabase
          .from('class_name')
          .select('id_class, name_class')
          .order('id_class', ascending: true);

      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      if (kDebugMode) {
        print('GET KELAS ERROR: $e');
      }
      return [];
    }
  }

  // ===============================
  // 🔹 INSERT DATA MURID
  // ===============================
  Future<void> addMurid({
    required int nis,
    required String nama,
    required int idClass,
    String? gender,
    DateTime? tanggalLahir,
    String? alamat,
    String? orangTua,
    int? noTele,
  }) async {
    try {
      await supabase.from('murid').insert({
        'user_id': userId,
        'nis': nis,
        'nama': nama,
        'id_class': idClass,
        'gender': gender,
        'tanggal_lahir': tanggalLahir?.toIso8601String().split('T').first,
        'alamat': alamat,
        'orang_tua': orangTua,
        'no_tele': noTele,
      });
    } catch (e) {
      if (kDebugMode) {
        print('ADD MURID ERROR: $e');
      }
      throw Exception(e);
    }
  }

  // ===============================
  // 🔹 UPDATE DATA MURID
  // pakai primary key id_tabel
  // ===============================
  Future<void> updateMurid({
    required String idTabel,
    required int nis,
    required String nama,
    required int idClass,
    String? gender,
    DateTime? tanggalLahir,
    String? alamat,
    String? orangTua,
    int? noTele,
  }) async {
    try {
      await supabase
          .from('murid')
          .update({
            'nis': nis,
            'nama': nama,
            'id_class': idClass,
            'gender': gender,
            'tanggal_lahir':
                tanggalLahir?.toIso8601String().split('T').first,
            'alamat': alamat,
            'orang_tua': orangTua,
            'no_tele': noTele,
          })
          .eq('id_tabel', idTabel)
          .eq('user_id', userId);
    } catch (e) {
      if (kDebugMode) {
        print('UPDATE MURID ERROR: $e');
      }
      throw Exception(e);
    }
  }

  // ===============================
  // 🔹 DELETE DATA MURID
  // pakai primary key id_tabel
  // ===============================
  Future<void> deleteMurid(String idTabel) async {
    try {
      await supabase
          .from('murid')
          .delete()
          .eq('id_tabel', idTabel)
          .eq('user_id', userId);
    } catch (e) {
      if (kDebugMode) {
        print('DELETE MURID ERROR: $e');
      }
      throw Exception(e);
    }
  }
}