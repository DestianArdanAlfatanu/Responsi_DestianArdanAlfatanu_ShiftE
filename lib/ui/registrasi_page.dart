import 'package:flutter/material.dart';
import 'package:responsi/bloc/registrasi_bloc.dart';
import 'package:responsi/ui/login_page.dart';
import 'package:responsi/widget/success_dialog.dart';
import 'package:responsi/widget/warning_dialog.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 19, 19), // Latar belakang hitam untuk tema monokrom
      appBar: AppBar(
        title: const Text('Registrasi', style: TextStyle(fontFamily: 'Georgia')),
        backgroundColor: Colors.white, // Warna AppBar yang lebih gelap
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white, // Latar belakang putih untuk kotak
              borderRadius: BorderRadius.circular(8.0), // Sudut membulat
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, 3), // Mengatur posisi bayangan
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  "Daftarkan Diri Anda Sekarang!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 8.0), // Jarak antar teks
                const Text(
                  "Isi form di bawah ini untuk mendaftar",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 16.0), // Jarak antar teks dan form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _namaTextField(),
                      _emailTextField(),
                      _passwordTextField(),
                      const SizedBox(height: 16.0), // Jarak antar widget
                      _buttonRegistrasi(),
                      const SizedBox(height: 30),
                      _menuLogin(),
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

  // Membuat Textbox nama
  Widget _namaTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama", labelStyle: TextStyle(color: Colors.black)),
      keyboardType: TextInputType.text,
      controller: _namaTextboxController,
      style: const TextStyle(fontFamily: 'Georgia', color: Colors.black),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Nama harus diisi';
        }
        return null;
      },
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
        if (value!.isEmpty) {
          return "Password harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Tombol Registrasi
  Widget _buttonRegistrasi() {
    return ElevatedButton(
      child: const Text("Registrasi", style: TextStyle(fontFamily: 'Georgia', color: Colors.white)), 
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) _submit();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[700], // Warna tombol
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0), // Padding untuk tombol
      ),
    );
  }

  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    RegistrasiBloc.registrasi(
      nama: _namaTextboxController.text,
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    ).then((value) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => SuccessDialog(
          description: "Registrasi berhasil, silahkan login",
          okClick: () {
            Navigator.pop(context); // Kembali ke halaman login
          },
        ),
      );
    }, onError: (error) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const WarningDialog(
          description: "Registrasi gagal, silahkan coba lagi",
        ),
      );
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  // Membuat menu untuk membuka halaman login
  Widget _menuLogin() {
    return Center(
      child: InkWell(
        child: RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: "Sudah punya akun? ",
                style: TextStyle(
                  color: Colors.grey, // Warna abu-abu untuk teks ini
                  fontFamily: 'Georgia',
                ),
              ),
              const TextSpan(
                text: "Login",
                style: TextStyle(
                  color: Colors.blue, // Warna biru untuk teks "Login"
                  fontFamily: 'Georgia',
                  decoration: TextDecoration.underline, // Garis bawah
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.pop(context); // Kembali ke halaman login
        },
      ),
    );
  }
}
