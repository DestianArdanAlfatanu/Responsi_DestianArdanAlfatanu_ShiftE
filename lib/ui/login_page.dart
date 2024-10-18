import 'package:flutter/material.dart';
import 'package:responsi/bloc/login_bloc.dart';
import 'package:responsi/helpers/user_info.dart';
import 'package:responsi/ui/registrasi_page.dart';
import 'package:responsi/ui/stress_page.dart';
import 'package:responsi/widget/warning_dialog.dart';
import 'package:flutter/gestures.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 19, 19), // Latar belakang hitam untuk tema monokrom
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(fontFamily: 'Georgia')),
        backgroundColor: Colors.white, // Warna AppBar yang lebih gelap
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Kotak dengan latar belakang putih
              borderRadius: BorderRadius.circular(12), // Membulatkan sudut
            ),
            padding: const EdgeInsets.all(16.0), // Jarak dalam kotak
            child: Column(
              children: [
                const Text(
                  "Sudahkah Anda Stress Hari Ini?",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 8.0), // Jarak antara teks
                const Text(
                  "Silahkan login untuk mengurangi stress Anda!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 16.0), // Jarak antara teks dan form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _emailTextField(),
                      _passwordTextField(),
                      const SizedBox(height: 20), // Jarak antara input dan tombol
                      _buttonLogin(),
                      const SizedBox(height: 30),
                      _menuRegistrasi(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }

  // Membuat Textbox email
  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Email", labelStyle: TextStyle(color: Colors.black)),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      style: const TextStyle(fontFamily: 'Georgia', color: Colors.black),
      validator: (value) {
        // Validasi harus diisi
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      },
    );
  }

  // Membuat Textbox password
  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Password", labelStyle: TextStyle(color: Colors.black)),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      style: const TextStyle(fontFamily: 'Georgia', color: Colors.black),
      validator: (value) {
        // Validasi harus diisi
        if (value!.isEmpty) {
          return "Password harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Tombol Login
  Widget _buttonLogin() {
    return ElevatedButton(
      child: const Text("Login", style: TextStyle(fontFamily: 'Georgia', color: Colors.white)),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) _submit();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[700], // Warna tombol
      ),
    );
  }

  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    LoginBloc.login(
            email: _emailTextboxController.text,
            password: _passwordTextboxController.text)
        .then((value) async {
      if (value.code == 200) {
        await UserInfo().setToken(value.token.toString());
        await UserInfo().setUserID(int.parse(value.userID.toString()));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const StressPage()));
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => const WarningDialog(
                  description: "Login gagal, silahkan coba lagi",
                ));
      }
    }, onError: (error) {
      print(error);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
                description: "Login gagal, silahkan coba lagi",
              ));
    });
  }

// Membuat menu untuk membuka halaman registrasi
Widget _menuRegistrasi() {
  return Center(
    child: RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.grey, fontFamily: 'Georgia'),
        children: [
          const TextSpan(text: "Belum punya akun? "),
          TextSpan(
            text: "Registrasi",
            style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline), // Warna biru dan garis bawah
            recognizer: TapGestureRecognizer() // Gesture untuk navigasi
              ..onTap = () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const RegistrasiPage()));
              },
          ),
        ],
      ),
    ),
  );
}
}