// lib/features/school_info/data/datasources/school_info_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:dirassati/core/services/colorLog.dart';
import 'package:dirassati/features/school_info/domain/models/school_info_model.dart';
import 'package:dirassati/features/school_info/domain/providers/school_info_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SchoolInfoRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage storage;

  // Debug token constant - matches your pattern from AbsencesRemoteDataSource
  static const String debugToken = "debug_dummy_token";

  SchoolInfoRemoteDataSource({
    required this.dio,
    required this.storage,
  });

  /// Fetches school information for a specific student
  /// In a real app, this would make an HTTP request to your backend
  Future<SchoolInfo> fetchSchoolInfo(String studentId) async {
    final token = await storage.read(key: 'auth_token');
    print(token);

    // Debug mode - return static data for testing
    if (token == debugToken || token == null) {
      clog("g", "ITs debug token");
      return _getDebugSchoolInfo();
    }

    try {
      // Real API call would go here
      final response = await dio.get(
        'https://$backendUrl/api/students/$studentId/school',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      // Parse the response and convert to SchoolInfo object
      final data = response.data as Map<String, dynamic>;

// flatten the address object to one line:
      final addr = data['address'] as Map<String, dynamic>? ?? {};
      final addressStr = [
        addr['street'],
        addr['city'],
        addr['state'],
        addr['postalCode'],
        addr['country'],
      ].where((s) => s != null && (s as String).isNotEmpty).join(', ');

      return SchoolInfo(
        name: data['name'] as String? ?? '',
        director: data['director'] as String? ?? 'Not specifeid',
        address: addressStr,
        phoneNumber: data['phoneNumber'] as String? ?? '',
        siteWeb: data['websiteUrl'] as String? ?? '',
        contactInfo: ContactInfo(
          phone1: data['phoneNumber'] as String? ?? '',
          phone2: '',
          phone3: '',
          email: data['email'] as String? ?? '',
        ),
        paymentInfo: PaymentInfo(
          paymentMode: data['bankCode'] as String? ?? '',
          accountRip: (data['billAmount'] ?? '').toString(),
        ),
      );
    } catch (e) {
      print("ERROR FETCHING SCHOOLL INFO!!!!$e");
      // If the API call fails, return debug data for now
      // In production, you'd want to handle this error properly
      return _getDebugSchoolInfo();
    }
  }

  /// Returns debug data that matches your expected format
  /// This helps you test the UI before connecting to real data
  SchoolInfo _getDebugSchoolInfo() {
    return SchoolInfo(
      name: 'Imad mohammed',
      address: 'wiam wiam, sidi bel abbes',
      director: 'Mr. Directeur',
      phoneNumber: 'Sidi Bel Abbes',
      siteWeb: 'www.esi-sba.dz',
      contactInfo: ContactInfo(
        phone1: '0666856565565',
        phone2: '0666856565565',
        phone3: '0666856565565',
        email: 'dre@esi-sba.dz',
      ),
      paymentInfo: PaymentInfo(
        paymentMode: 'compte courant postal',
        accountRip: '1212121-121212212-2122',
      ),
    );
  }
}
