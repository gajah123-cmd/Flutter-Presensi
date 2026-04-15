import 'package:supabase_flutter/supabase_flutter.dart';

class ClassService {

  static final supabase = Supabase.instance.client;
  static Future<List<Map<String, dynamic>>> getKelas() async {
  final response = await supabase
      .from('kelas')
      .select('id, name') 
      .order('id');

  return List<Map<String, dynamic>>.from(response);
}
  
  static Future<List<Map<String, dynamic>>> getClasses() async {
    final response = await supabase.from('class_name').select();
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<Map<String, dynamic>?> getClassById(int id) async {
    final response = await supabase
        .from('class_name')
        .select()
        .eq('id_class', id)
        .maybeSingle();

    return response;
  }
}

