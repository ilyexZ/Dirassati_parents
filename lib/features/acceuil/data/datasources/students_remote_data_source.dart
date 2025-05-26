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
    try {
      // Read token from secure storage.
      final token = await storage.read(key: 'auth_token');
      if (token == null) {
        clog('r', 'No auth token found');
        return _getStaticStudents();
      }

      // If debug token, return static list immediately
      if (token == debugToken) {
        clog('y', 'Debug token detected. Returning static students.');
        return _getStaticStudents();
      }

      // Decode token and extract parent ID
      final decodedToken = JwtDecoder.decode(token);
      final extractedParentId = decodedToken['parentId'];
      if (extractedParentId == null) {
        clog('r', 'Parent ID not found in token');
        return _getStaticStudents();
      }

      // Perform GET request
      final response = await dio.get(
        "http://$backendUrl/api/parents/$extractedParentId/students",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        clog('b', 'Fetched ${data.length} students from API.');
        return data.map((json) => Student.fromJson(json)).toList();
      } else {
        final msg = 'Failed to fetch students: '
            'Status ${response.statusCode}, '
            'Response: ${response.data}';
        clog('r', msg);
        return _getStaticStudents();
      }
    } on DioError catch (e) {
      final status = e.response?.statusCode;
      final respData = e.response?.data;
      clog('r', 'DioError fetching students: ${e.message}, '
          'Status: $status, Data: $respData');
      return _getStaticStudents();
    } catch (e, stack) {
      clog('r', 'Unexpected error fetching students: $e\n$stack');
      return _getStaticStudents();
    }
  }

  List<Student> _getStaticStudents() {
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
    ];
  }

  Future<List<Note>> fetchStudentNotes(String studentId) async {
    try {
      final token = await storage.read(key: 'auth_token');
      if (token == debugToken || token == null) {
        clog('y', 'Debug token or no token: returning static notes.');
        return _getDebugNotes();
      }

      final response = await dio.get(
        'http://$backendUrl/api/Notes/$studentId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final notesData = response.data['notes'] as List;
        return notesData.map((json) => Note.fromJson(json)).toList();
      } else {
        clog('r', 'Failed to fetch notes: Status ${response.statusCode}, Data: ${response.data}');
        return _getDebugNotes();
      }
    } on DioError catch (e) {
      clog('r', 'DioError fetching notes: ${e.message}, '
          'Status: ${e.response?.statusCode}, Data: ${e.response?.data}');
      return _getDebugNotes();
    } catch (e, stack) {
      clog('r', 'Unexpected error fetching notes: $e\n$stack');
      return _getDebugNotes();
    }
  }

  List<Note> _getDebugNotes() => debugNotes;
}
