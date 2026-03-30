import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class LaporanService {
  static Future<List<Map<String, dynamic>>> getLaporan() async {
    final response = await supabase
        .from('PelaporanJalan')
        .select()
        .order('tanggal', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  static Future insertLaporan(Map<String, dynamic> data) async {
    await supabase.from('PelaporanJalan').insert(data);
  }

  static Future updateLaporan(String id, Map<String, dynamic> data) async {
    await supabase.from('PelaporanJalan').update(data).eq('id', id);
  }

  static Future deleteLaporan(String id) async {
    await supabase.from('PelaporanJalan').delete().eq('id', id);
  }
}
