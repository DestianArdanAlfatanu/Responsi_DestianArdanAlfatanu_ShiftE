import 'package:flutter/material.dart';
import 'package:responsi/model/stress.dart';
import 'package:responsi/ui/edit_stress_page.dart';

class DetailStressPage extends StatefulWidget {
  final Stress stress;
  final Function(Stress) onUpdate;
  final Function(Stress) onDelete;

  const DetailStressPage({
    Key? key,
    required this.stress,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  _DetailStressPageState createState() => _DetailStressPageState();
}

class _DetailStressPageState extends State<DetailStressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Stress'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        const Text('ID', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('${widget.stress.id}', style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text('Stress Factor', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('${widget.stress.stressFactor}', style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text('Coping Strategy', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('${widget.stress.copingStrategy}', style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text('Stress Level', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('${widget.stress.stressLevel}', style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _actionButtons(), // Use a method for Edit and Delete buttons
          ],
        ),
      ),
    );
  }

  Widget _actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditStressPage(stress: widget.stress),
              ),
            ).then((updatedStress) {
              if (updatedStress != null) {
                widget.onUpdate(updatedStress);
                Navigator.pop(context);
              }
            });
          },
          child: const Text('Edit'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => _confirmDelete(),
          child: const Text('Delete'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _confirmDelete() {
    AlertDialog alertDialog = AlertDialog(
      title: const Text('Delete Data'),
      content: const Text('Are you sure you want to delete this data?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onDelete(widget.stress);
            Navigator.of(context).pop(); // Close the confirmation dialog
            Navigator.pop(context); // Return to the previous page after deletion
          },
          child: const Text('Delete'),
        ),
      ],
    );
    showDialog(context: context, builder: (BuildContext context) => alertDialog);
  }
}
