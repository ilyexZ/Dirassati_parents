// lib/features/school_info/domain/providers/school_info_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/school_info_model.dart';

// Provider for school information - can be switched between debug and real data
final schoolInfoProvider = FutureProvider<SchoolInfo>((ref) async {
  // For debugging, return static data
  // In production, this would fetch from your API
  return _getDebugSchoolInfo();
});

// Debug data function - simulates API response
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

// Alternative provider that could fetch from API in the future
final schoolInfoRepositoryProvider = Provider<SchoolInfoRepository>((ref) {
  // This would typically inject your HTTP client and other dependencies
  return SchoolInfoRepository();
});

class SchoolInfoRepository {
  // Future method that would fetch real data from your backend
  Future<SchoolInfo> fetchSchoolInfo() async {
    // Simulate network delay for realistic behavior
    await Future.delayed(const Duration(milliseconds: 500));
    
    // In a real implementation, you would:
    // 1. Get the auth token from secure storage
    // 2. Make HTTP request to your API endpoint
    // 3. Parse the JSON response into SchoolInfo model
    // 4. Handle errors appropriately
    
    return _getDebugSchoolInfo();
  }
}