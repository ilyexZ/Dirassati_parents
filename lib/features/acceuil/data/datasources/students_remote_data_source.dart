import 'package:dio/dio.dart';
import 'package:dirassati/core/services/colorLog.dart';
import 'package:dirassati/core/shared_constants.dart';
import 'package:dirassati/features/acceuil/data/models/note_model.dart';
import 'package:dirassati/features/acceuil/data/staticnotes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/student_model.dart';

class StudentsRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage storage;
  String get backendUrl => BackendProvider.backendProviderIp;



  // Define a debug token for debugging purposes.
  static const String debugToken = "debug_dummy_token";

  StudentsRemoteDataSource({
    required this.dio,
    required this.storage,
  });

  Future<List<Student>> getStudents(String parentId) async {
  // Use parentId in the API call
  //final response = await dio.get("http://$backendUrl/api/parents/$parentId/students");
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
    final response = await dio.get("http://$backendUrl/api/parents/$parentId/students");
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      clog("b", data);
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
  Future<List<Note>> fetchStudentNotes(String studentId) async {
  final token = await storage.read(key: 'auth_token');

  if (token == StudentsRemoteDataSource.debugToken || token == null) {
    return _getDebugNotes();
  }

  final response = await dio.get(
    'http://$backendUrl/api/Notes/$studentId',
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );

  final notesData = response.data['notes'] as List;
  return notesData.map((json) => Note.fromJson(json)).toList();
}

List<Note> _getDebugNotes() {
  return debugNotes;
}

}