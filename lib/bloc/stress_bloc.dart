import 'dart:convert';
import 'package:responsi/helpers/api.dart';
import 'package:responsi/helpers/api_url.dart';
import 'package:responsi/model/stress.dart';

class StressBloc {
  // Fungsi untuk mendapatkan daftar data manajemen stres
  static Future<List<Stress>> getStressData() async {
    String apiUrl = ApiUrl.listStress;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listStress = (jsonObj as Map<String, dynamic>)['data'];
    List<Stress> stressData = [];
    for (int i = 0; i < listStress.length; i++) {
      stressData.add(Stress.fromJson(listStress[i]));
    }
    return stressData;
  }

  // Mendapatkan daftar manajemen stres
  static Future<List<Stress>> getStressRecords() async {
    String apiUrl = ApiUrl.listStress; // Pastikan ini sesuai dengan endpoint API Anda
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    
    // Cek status dari respons API
    if (jsonObj['status'] != true) {
      throw Exception('Failed to load stress records'); // Tangani kesalahan dengan melempar pengecualian
    }

    List<dynamic> listStress = (jsonObj['data'] as List<dynamic>);
    List<Stress> stresses = listStress.map((item) => Stress.fromJson(item)).toList();
    
    return stresses;
  }

  // Fungsi untuk menambahkan data manajemen stres
  static Future<bool> addStress({Stress? stress}) async {
    String apiUrl = ApiUrl.createStress;
    var body = {
      "stress_factor": stress!.stressFactor,
      "coping_strategy": stress.copingStrategy,
      "stress_level": stress.stressLevel.toString()
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  // Fungsi untuk memperbarui data manajemen stres
  static Future<bool> updateStress({required Stress stress}) async {
    String apiUrl = ApiUrl.updateStress(stress.id!);
    var body = {
      "stress_factor": stress.stressFactor,
      "coping_strategy": stress.copingStrategy,
      "stress_level": stress.stressLevel.toString()
    };
    var response = await Api().put(apiUrl, jsonEncode(body));
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  // Fungsi untuk menghapus data manajemen stres
  static Future<bool> deleteStress({required int id}) async {
    String apiUrl = ApiUrl.deleteStress(id);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['data'];
  }
  
}
