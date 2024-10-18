import 'package:flutter/material.dart';
import 'package:responsi/bloc/stress_bloc.dart';
import 'package:responsi/model/stress.dart';
import 'package:responsi/helpers/user_info.dart';
import 'package:responsi/ui/login_page.dart';
import 'package:responsi/ui/detail_stress_page.dart';
import 'package:responsi/ui/edit_stress_page.dart';

class StressPage extends StatefulWidget {
  const StressPage({Key? key}) : super(key: key);

  @override
  _StressPageState createState() => _StressPageState();
}

class _StressPageState extends State<StressPage> {
  bool _isLoggedIn = false;
  List<Stress>? _stressRecords; // Variabel untuk menyimpan data stress

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    var token = await UserInfo().getToken();
    if (token == null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    } else {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  Future<void> _logout() async {
    await UserInfo().logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  void _updateStress(Stress updatedStress) {
    setState(() {
      // Cari data stress yang telah diperbarui di daftar berdasarkan id
      final index = _stressRecords?.indexWhere((stress) => stress.id == updatedStress.id);

      if (index != null && index != -1) {
        // Ganti data yang lama dengan data yang baru
        _stressRecords![index] = updatedStress;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Stress'),
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            children: [
              ListTile(
                title: Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.white,
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                trailing: const Icon(Icons.logout, color: Colors.black),
                onTap: () {
                  _logout();
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 20, 19, 19),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'List Manajemen Stress',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {}); // Refresh halaman
                    },
                    child: const Text('Refresh'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Arahkan ke halaman EditStressPage untuk menambah data baru
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditStressPage(
                            stress: Stress(), // Buat objek Stress baru untuk ditambahkan
                          ),
                        ),
                      );
                    },
                    child: const Text('Tambah Data'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder<List<Stress>>(
                    future: StressBloc.getStressRecords(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // Simpan data ke variabel _stressRecords
                      _stressRecords = snapshot.data;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Expanded(child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(child: Text('Stress Factor', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(child: Text('Coping Strategy', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(child: Text('Stress Level', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                          ),
                          const Divider(),
                          ..._stressRecords!.map((stress) {
                            return GestureDetector(
                              onTap: () async {
                                // Arahkan ke halaman DetailStressPage saat baris data diklik
                                final updatedStress = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailStressPage(
                                      stress: stress, // Kirim data stress yang dipilih ke halaman detail
                                      onUpdate: _updateStress, // Callback untuk memperbarui data
                                      onDelete: (deletedStress) {
                                        setState(() {
                                          // Hapus data dari daftar jika dihapus di halaman detail
                                          _stressRecords!.removeWhere((s) => s.id == deletedStress.id);
                                        });
                                      },
                                    ),
                                  ),
                                );

                                if (updatedStress != null) {
                                  _updateStress(updatedStress); // Memperbarui data di halaman StressPage jika ada perubahan
                                }
                              },
                              child: Row(
                                children: [
                                  Expanded(child: Text(stress.id.toString(), textAlign: TextAlign.left)),
                                  Expanded(child: Text(stress.stressFactor ?? '', textAlign: TextAlign.left)),
                                  Expanded(child: Text(stress.copingStrategy ?? '', textAlign: TextAlign.left)),
                                  Expanded(child: Text(stress.stressLevel?.toString() ?? '0', textAlign: TextAlign.left)),
                                ],
                              ),
                            );

                          }).toList(),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
