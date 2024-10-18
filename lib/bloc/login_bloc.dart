import 'dart:convert';
import 'package:responsi/helpers/api.dart';
import 'package:responsi/helpers/api_url.dart';
import 'package:responsi/model/login.dart';

class LoginBloc {
  static Future<Login> login({String? email, String? password}) async {
    // Mendapatkan URL API untuk login
    String apiUrl = ApiUrl.login;
    
    // Membuat body request dengan email dan password
    var body = {"email": email, "password": password};
    
    // Mengirim request POST ke API
    var response = await Api().post(apiUrl, body);
    
    // Mengubah response yang didapat menjadi objek JSON
    var jsonObj = json.decode(response.body);
    
    // Mengembalikan data login yang sudah diparse ke dalam model Login
    return Login.fromJson(jsonObj);
  }
}
