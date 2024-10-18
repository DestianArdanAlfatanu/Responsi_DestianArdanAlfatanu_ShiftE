import 'package:flutter/material.dart';
import 'package:responsi/model/stress.dart';

class EditStressPage extends StatefulWidget {
  final Stress stress;

  const EditStressPage({Key? key, required this.stress}) : super(key: key);

  @override
  _EditStressPageState createState() => _EditStressPageState();
}

class _EditStressPageState extends State<EditStressPage> {
  final TextEditingController _stressFactorController = TextEditingController();
  final TextEditingController _copingStrategyController = TextEditingController();
  final TextEditingController _stressLevelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _stressFactorController.text = widget.stress.stressFactor ?? '';
    _copingStrategyController.text = widget.stress.copingStrategy ?? '';
    _stressLevelController.text = widget.stress.stressLevel?.toString() ?? '0';
  }

  void _saveChanges() {
    // Mengirimkan data yang telah diperbarui kembali ke halaman List Stress
    Navigator.pop(
      context,
      Stress(
        id: widget.stress.id,
        stressFactor: _stressFactorController.text,
        copingStrategy: _copingStrategyController.text,
        stressLevel: int.tryParse(_stressLevelController.text),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Stress',
          style: TextStyle(color: Colors.black), 
        ),
        backgroundColor: Colors.white, 
        iconTheme: const IconThemeData(color: Colors.black), 
      ),
      body: Container(
        color: const Color.fromARGB(255, 20, 19, 19),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _stressFactorController,
              decoration: const InputDecoration(labelText: 'Stress Factor', labelStyle: TextStyle(color: Colors.white)),
              style: const TextStyle(color: Colors.white),
            ),
            TextField(
              controller: _copingStrategyController,
              decoration: const InputDecoration(labelText: 'Coping Strategy', labelStyle: TextStyle(color: Colors.white)),
              style: const TextStyle(color: Colors.white),
            ),
            TextField(
              controller: _stressLevelController,
              decoration: const InputDecoration(labelText: 'Stress Level', labelStyle: TextStyle(color: Colors.white)),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
