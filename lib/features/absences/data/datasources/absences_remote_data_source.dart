import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/absence_model.dart';

class AbsencesRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage storage;
  
  // Debug token constant - matches your pattern from StudentsRemoteDataSource
  static const String debugToken = "debug_dummy_token";

  AbsencesRemoteDataSource({
    required this.dio,
    required this.storage,
  });

  /// Fetches absences for a specific student and trimester
  /// In a real app, this would make an HTTP request to your backend
  Future<List<Absence>> fetchAbsences(String studentId, String trimester) async {
    final token = await storage.read(key: 'auth_token');
    
    // Debug mode - return static data for testing
    if (token == debugToken || token == null) {
      return _getDebugAbsences(studentId, trimester);
    }

    try {
      // Real API call would go here
      final response = await dio.get(
        '/api/absences',
        queryParameters: {
          'studentId': studentId,
          'trimester': trimester,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      // Parse the response and convert to Absence objects
      final List<dynamic> data = response.data['absences'] ?? [];
      return data.map((json) => Absence.fromJson(json)).toList();
    } catch (e) {
      // If the API call fails, return debug data for now
      // In production, you'd want to handle this error properly
      return _getDebugAbsences(studentId, trimester);
    }
  }

  /// Returns debug data that matches your screenshot format
  /// This helps you test the UI before connecting to real data
  List<Absence> _getDebugAbsences(String studentId, String trimester) {
    // Create some sample data that matches your screenshot
    final baseDate = DateTime(2025, 1, 25);
    
    return [
      Absence(
        id: '1',
        studentId: studentId,
        studentName: 'Mr.mohammed karim',
        date: baseDate,
        time: '12:00',
        trimester: trimester,
        type: 'unjustified',
      ),
      Absence(
        id: '2',
        studentId: studentId,
        studentName: 'Mr.mohammed karim',
        date: baseDate,
        time: '12:00',
        trimester: trimester,
        type: 'unjustified',
      ),
      Absence(
        id: '3',
        studentId: studentId,
        studentName: 'Mr.mohammed karim',
        date: baseDate,
        time: '12:00',
        trimester: trimester,
        type: 'unjustified',
      ),
    ];
  }

  /// Fetches all absences for a student across all trimesters
  /// This is useful for getting a complete overview
  Future<List<Absence>> fetchAllAbsences(String studentId) async {
    final List<Absence> allAbsences = [];
    
    // Fetch absences for each trimester
    for (int i = 1; i <= 3; i++) {
      final trimesterAbsences = await fetchAbsences(studentId, 'Trimestre $i');
      allAbsences.addAll(trimesterAbsences);
    }
    
    return allAbsences;
  }
}