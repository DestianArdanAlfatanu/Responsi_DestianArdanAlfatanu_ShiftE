class Stress {
  int? id;
  String? stressFactor;
  String? copingStrategy;
  int? stressLevel;

  // Konstruktor untuk kelas Stress
  Stress({this.id, this.stressFactor, this.copingStrategy, this.stressLevel});

  // Factory method untuk membuat objek Stress dari data JSON
  factory Stress.fromJson(Map<String, dynamic> obj) {
    return Stress(
      id: obj['id'],
      stressFactor: obj['stress_factor'],
      copingStrategy: obj['coping_strategy'],
      stressLevel: int.tryParse(obj['stress_level'].toString()) ?? 0,
    );
  }
}
