import 'package:flutter/material.dart';
import 'package:responsi/helpers/user_info.dart';
import 'package:responsi/ui/login_page.dart';
import 'package:responsi/ui/stress_page.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = const CircularProgressIndicator(); // Menampilkan loading spinner

  @override
  void initState() {
    super.initState();
    checkLoginStatus(); // Memanggil fungsi untuk memeriksa status login
  }

  void checkLoginStatus() async {
    var token = await UserInfo().getToken(); // Mengambil token dari UserInfo
    if (token != null) {
      // Jika token ada, redirect ke halaman yang diinginkan
      setState(() {
        page = const StressPage(); // Ganti dengan halaman yang sesuai
      });
    } else {
      // Jika token tidak ada, redirect ke halaman login
      setState(() {
        page = const LoginPage(); // Halaman login
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Manajemen Stress',
      debugShowCheckedModeBanner: false,
      home: page, // Menampilkan halaman yang ditentukan di atas
    );
  }
}
