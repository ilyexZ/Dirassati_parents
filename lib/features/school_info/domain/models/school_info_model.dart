// lib/features/school_info/domain/models/school_info_model.dart

/// Main model representing all school information
class SchoolInfo {
  final String name;
  final String address;
  final String director;
  final String phoneNumber;  // This appears to be used for location in your UI
  final String siteWeb;
  final ContactInfo contactInfo;
  final PaymentInfo paymentInfo;

  SchoolInfo({
    required this.name,
    required this.address,
    required this.director,
    required this.phoneNumber,
    required this.siteWeb,
    required this.contactInfo,
    required this.paymentInfo,
  });

  /// Factory constructor to create SchoolInfo from JSON
  /// This follows the pattern you'll need when fetching from your API
  factory SchoolInfo.fromJson(Map<String, dynamic> json) {
    return SchoolInfo(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      director: json['director'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      siteWeb: json['siteWeb'] ?? '',
      contactInfo: ContactInfo.fromJson(json['contactInfo'] ?? {}),
      paymentInfo: PaymentInfo.fromJson(json['paymentInfo'] ?? {}),
    );
  }

  /// Convert SchoolInfo to JSON - useful for caching or API requests
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'director': director,
      'phoneNumber': phoneNumber,
      'siteWeb': siteWeb,
      'contactInfo': contactInfo.toJson(),
      'paymentInfo': paymentInfo.toJson(),
    };
  }
}

/// Model for contact information section
class ContactInfo {
  final String phone1;
  final String phone2;
  final String phone3;
  final String email;

  ContactInfo({
    required this.phone1,
    required this.phone2,
    required this.phone3,
    required this.email,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      phone1: json['phone1'] ?? '',
      phone2: json['phone2'] ?? '',
      phone3: json['phone3'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone1': phone1,
      'phone2': phone2,
      'phone3': phone3,
      'email': email,
    };
  }

  /// Helper method to get all phone numbers as a list
  /// This makes it easier to display them in the UI
  List<String> getAllPhones() {
    return [phone1, phone2, phone3].where((phone) => phone.isNotEmpty).toList();
  }
}

/// Model for payment information section
class PaymentInfo {
  final String paymentMode;
  final String accountRip;

  PaymentInfo({
    required this.paymentMode,
    required this.accountRip,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      paymentMode: json['paymentMode'] ?? '',
      accountRip: json['accountRip'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentMode': paymentMode,
      'accountRip': accountRip,
    };
  }
}