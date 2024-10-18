import 'dart:convert';
import 'package:responsi/helpers/api.dart';
import 'package:responsi/helpers/api_url.dart';
import 'package:responsi/model/registrasi.dart';

class RegistrasiBloc {
  // Fungsi registrasi untuk mendaftarkan pengguna baru
  static Future<Registrasi> registrasi(
      {String? nama, String? email, String? password}) async {
    // Mendapatkan URL API untuk registrasi
    String apiUrl = ApiUrl.registrasi;
    
    // Membuat body request dengan nama, email, dan password
    var body = {"nama": nama, "email": email, "password": password};
    
    // Mengirim request POST ke API untuk melakukan registrasi
    var response = await Api().post(apiUrl, body);
    
    // Mengubah response yang didapat menjadi objek JSON
    var jsonObj = json.decode(response.body);
    
    // Mengembalikan data registrasi yang sudah diparse ke dalam model Registrasi
    return Registrasi.fromJson(jsonObj);
  }
}