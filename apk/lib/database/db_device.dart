import 'package:supabase_flutter/supabase_flutter.dart';

class DeviceService {
  static final supabase = Supabase.instance.client;

  static String get userId {
    final id = supabase.auth.currentUser?.id;
    if (id == null) {
      throw Exception('User belum login');
    }
    return id;
  }

  // 🔹 MENDAPATKAN DATA ALAT SECARA REAL-TIME
  static Stream<List<Map<String, dynamic>>> getDevicesStream() {
    return supabase
        .from('address_alat')
        .stream(primaryKey: ['id_tabel'])
        .eq('user_id', userId)
        .order('status', ascending: false);
  }

  // 🔹 MENDAFTARKAN ALAT (REQUEST KONFIRMASI IOT)
  static Future<void> requestDevice(num idAlat) async {
    // 1. Cek apakah id_alat ada di database
    final response = await supabase
        .from('address_alat')
        .select()
        .eq('id_alat', idAlat)
        .maybeSingle();

    if (response == null) {
      throw Exception("ID Alat tidak ditemukan di database!");
    }

    // Jika alat sudah ada pemiliknya (user_id tidak null dan beda dengan current user)
    // Note: Jika user_id sama, artinya mencoba merequest ulang.
    if (response['user_id'] != null && response['user_id'] != userId) {
      throw Exception("Alat sudah didaftarkan oleh pengguna lain!");
    }

    // 2. Update status untuk mengirim kode 00 ke alat
    await supabase.from('address_alat').update({
      'user_id': userId,
      'data_keluar': '00',
      'data_masuk': null, // Kosongkan agar bisa menunggu balasan 11
      'status': DateTime.now().toUtc().toIso8601String(), // Waktu request
    }).eq('id_alat', idAlat);
  }

  // 🔹 MEMBATALKAN REQUEST / MENGHAPUS ALAT (TIME OUT ATAU HAPUS MANUAL)
  static Future<void> cancelOrRemoveDevice(String idTabel) async {
    await supabase.from('address_alat').update({
      'user_id': null,
      'data_keluar': null,
      'data_masuk': null,
    }).eq('id_tabel', idTabel);
  }
}
