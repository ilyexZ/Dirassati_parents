import 'package:dio/dio.dart';
import 'package:dirassati/core/shared_constants.dart';
import 'package:dirassati/features/acceuil/data/models/note_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/student_model.dart';

class StudentsRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage storage;

  // Define a debug token for debugging purposes.
  static const String debugToken = "debug_dummy_token";

  StudentsRemoteDataSource({
    required this.dio,
    required this.storage,
  });

  Future<List<Student>> getStudents() async {
    // Read token from secure storage.
    final token = await storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception("No auth token found");
    }
    
    // Check if token is our debug token.
    if (token == debugToken) {
      return _getStaticStudents();
    }
    
    // Decode token using jwt_decoder package.
    final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    // Extract the parent ID. Adjust the key name if needed.
    final parentId = decodedToken['parentId'];
    if (parentId == null) {
      throw Exception("Parent ID not found in token");
    }
    
    // Make the GET request using the extracted parentId.
    final response = await dio.get("http://$backendProviderIp/api/parents/$parentId/students");
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch students");
    }
  }

  List<Student> _getStaticStudents() {
    // Return a static list of students for debugging purposes.
    return [
      Student(
        studentId: "debug-1",
        firstName: "Debug",
        lastName: "Student One",
        enrollmentDate: "2025-01-01",
        grade: "1st Grade",
        isActive: true,
      ),
      Student(
        studentId: "debug-2",
        firstName: "Debug",
        lastName: "Student Two",
        enrollmentDate: "2025-01-02",
        grade: "2nd Grade",
        isActive: true,
      ),
      // Add more static students if needed.
    ];
  }
  // New method to fetch notes for a given category.
  Future<List<Note>> fetchNotes(String category, String trimester) async {
    // Replace with your actual endpoint.
    const endpoint = "https://api.example.com/notes";
    final response = await dio.get(endpoint, queryParameters: {
      'category': category,
      'trimester': trimester,
    });
    if (response.statusCode == 200) {
      final List data = response.data as List;
      return data.map((json) => Note.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load notes");
    }
  }
}
