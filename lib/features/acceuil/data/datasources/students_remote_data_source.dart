import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/student_model.dart';

class StudentsRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage storage;

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
    print('token: $token');
    // Decode token using jwt_decoder package.
    final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    // Extract the parent ID. Adjust the key name if needed.
    final parentId = decodedToken['parentId'];
    print('parentId: $parentId');
    if (parentId == null) {
      throw Exception("Parent ID not found in token");
    }
    
    // Make the GET request using the extracted parentId.
    final response = await dio.get("http://192.168.1.8:5080/api/parents/$parentId/students");
    if (response.statusCode == 200) {
      print("data retrieved: ${response.data}");
      final List<dynamic> data = response.data;
      return data.map((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch students");
    }
  }
}
