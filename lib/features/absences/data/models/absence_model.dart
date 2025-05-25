// lib/features/absences/data/models/absence_model.dart
class Absence {
  final String id;
  final String studentId;
  final String studentName;
  final DateTime date;
  final String time;
  final String trimester;
  final String type; // 'justified' or 'unjustified'
  final String? reason;

  Absence({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.date,
    required this.time,
    required this.trimester,
    required this.type,
    this.reason,
  });

  // Factory constructor for creating from JSON - useful when you get real API data
  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      date: DateTime.parse(json['date']),
      time: json['time'] ?? '',
      trimester: json['trimester'] ?? '',
      type: json['type'] ?? 'unjustified',
      reason: json['reason'],
    );
  }

  // Convert to JSON - useful for sending data to API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'date': date.toIso8601String(),
      'time': time,
      'trimester': trimester,
      'type': type,
      'reason': reason,
    };
  }
}

// 
