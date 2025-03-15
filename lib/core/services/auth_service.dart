import 'package:dio/dio.dart';
import '../../features/auth/data/models/user_model.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:5000/api/auth'));

  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {"email": email, "password": password});
      return UserModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}
