import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class Murid {
  final num nis;
  final DateTime? createdAt;
  final String nama;
  final num idClass;
  final String? gender;
  final DateTime? tanggalLahir;
  final String? alamat;
  final String? orangTua;
  final num? noTele;

  Murid({
    required this.nis,
    this.createdAt,
    required this.nama,
    required this.idClass,
    this.gender,
    this.tanggalLahir,
    this.alamat,
    this.orangTua,
    this.noTele,
  });

  factory Murid.fromJson(Map<String, dynamic> json) {
    return Murid(
      nis: json['nis'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      nama: json['nama'],
      idClass: json['id_class'],
      gender: json['gender'],
      tanggalLahir: json['tanggal_lahir'] != null
          ? DateTime.parse(json['tanggal_lahir'])
          : null,
      alamat: json['alamat'],
      orangTua: json['orang_tua'],
      noTele: json['no_tele'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nis': nis,
      'nama': nama,
      'id_class': idClass,
      'gender': gender,
      'tanggal_lahir': tanggalLahir?.toIso8601String(),
      'alamat': alamat,
      'orang_tua': orangTua,
      'no_tele': noTele,
    };
  }
}

Future<void> insertMurid(Murid murid) async {
  await supabase.from('murid').insert({
    ...murid.toJson(),
    // created_at otomatis dari DB
  });
}

Future<List<Murid>> getMurid() async {
  final response = await supabase
      .from('murid')
      .select()
      .order('created_at', ascending: false);

  return (response as List)
      .map((e) => Murid.fromJson(e))
      .toList();
}

Future<void> updateMurid(Murid murid) async {
  await supabase
      .from('murid')
      .update(murid.toJson())
      .eq('nis', murid.nis);
}

Future<void> deleteMurid(num nis) async {
  await supabase
      .from('murid')
      .delete()
      .eq('nis', nis);
}