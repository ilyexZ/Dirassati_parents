import 'package:dirassati/core/services/colorLog.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dirassati/core/shared_constants.dart';

/// Payment initiation response model
class PaymentInitiationResponse {
  final String checkoutUrl;
  final String checkoutId;

  PaymentInitiationResponse({
    required this.checkoutUrl,
    required this.checkoutId,
  });

  factory PaymentInitiationResponse.fromJson(Map<String, dynamic> json) {
    // Add validation and better error handling
    if (json['checkoutUrl'] == null || json['checkoutId'] == null) {
      throw Exception('Invalid response: missing checkoutUrl or checkoutId');
    }
    
    final checkoutUrl = json['checkoutUrl'] as String;
    final checkoutId = json['checkoutId'] as String;
    
    if (checkoutUrl.isEmpty || checkoutId.isEmpty) {
      throw Exception('Invalid response: empty checkoutUrl or checkoutId');
    }
    
    return PaymentInitiationResponse(
      checkoutUrl: checkoutUrl,
      checkoutId: checkoutId,
    );
  }

  @override
  String toString() {
    return 'PaymentInitiationResponse{checkoutUrl: $checkoutUrl, checkoutId: $checkoutId}';
  }
}

/// Service class for payment-related API calls
class PaymentApiService {
  // Initialize secure storage
  static const storage = FlutterSecureStorage();
  
  // Initialize Dio instance with better configuration
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );
  
  // Use the backend URL from your shared constants
  static String get baseUrl => 'https://${BackendProvider.backendProviderIp}/api';

  /// Initiates a payment for the given student ID
  /// Returns PaymentInitiationResponse with checkout URL and ID
  static Future<PaymentInitiationResponse> initiatePayment(String studentId) async {
    //print('🚀 PaymentApiService: Starting payment initiation for student: $studentId');
    
    // Read the token inside the method
    final token = await storage.read(key: 'auth_token');
    clog("r", "Token: $token");

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found. Please login again.');
    }

    final url = '$baseUrl/Payments/initiate';
    final requestBody = {'studentId': studentId};

    print('📡 Making POST request to: $url');
    print('📦 Request body: $requestBody');
    print('🔑 Authorization header: Bearer ${token.substring(0, 10)}...');

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
            'ngrok-skip-browser-warning': 'true', // For ngrok development
          },
          validateStatus: (status) {
            // Accept status codes between 200-299 as successful
            return status != null && status >= 200 && status < 300;
          },
        ),
        data: requestBody,
      );

      print('📨 Response status code: ${response.statusCode}');
      print('📄 Response headers: ${response.headers}');
      print('📄 Response body: ${response.data}');

      if (response.statusCode == 200) {
        print('✅ Successfully received response');
        
        // Validate response data type
        if (response.data == null) {
          throw Exception('Null response data received from server');
        }
        
        if (response.data is! Map<String, dynamic>) {
          print('❌ Response data is not a Map: ${response.data.runtimeType}');
          throw Exception('Invalid response format: expected JSON object, got ${response.data.runtimeType}');
        }
        
        final responseData = response.data as Map<String, dynamic>;
        print('📊 Parsed response data: $responseData');
        
        final paymentResponse = PaymentInitiationResponse.fromJson(responseData);
        print('✅ Successfully parsed PaymentInitiationResponse: $paymentResponse');
        
        return paymentResponse;
      } else {
        print('❌ API request failed with status ${response.statusCode}');
        print('❌ Response data: ${response.data}');
        throw Exception('Failed to initiate payment (Status: ${response.statusCode})');
      }
    } on DioException catch (e) {
      print('❌ Dio error occurred: ${e.type} - ${e.message}');
      print('❌ Request options: ${e.requestOptions.uri}');
      
      if (e.response != null) {
        print('❌ Error response status: ${e.response?.statusCode}');
        print('❌ Error response headers: ${e.response?.headers}');
        print('❌ Error response data: ${e.response?.data}');
        
        if (e.response?.statusCode == 401) {
          throw Exception('Authentication failed. Please login again.');
        } else if (e.response?.statusCode == 404) {
          throw Exception('Payment service not found. Please contact support.');
        } else if (e.response?.statusCode == 500) {
          throw Exception('Server error occurred. Please try again later.');
        } else {
          // Try to parse error message from response data
          String errorMessage = 'Failed to initiate payment';
          try {
            final errorData = e.response?.data;
            if (errorData is Map<String, dynamic>) {
              if (errorData.containsKey('message')) {
                errorMessage = errorData['message'];
              } else if (errorData.containsKey('error')) {
                errorMessage = errorData['error'];
              } else if (errorData.containsKey('title')) {
                errorMessage = errorData['title'];
              }
            } else if (errorData is String && errorData.isNotEmpty) {
              errorMessage = errorData;
            }
          } catch (parseError) {
            print('⚠️ Failed to parse error response: $parseError');
            // Use default error message if parsing fails
          }
          throw Exception('$errorMessage (Status: ${e.response?.statusCode})');
        }
      } else {
        // Handle network errors
        String errorMessage;
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            errorMessage = 'Connection timeout. Please check your internet connection and try again.';
            break;
          case DioExceptionType.sendTimeout:
            errorMessage = 'Request timeout. Please try again.';
            break;
          case DioExceptionType.receiveTimeout:
            errorMessage = 'Response timeout. Please try again.';
            break;
          case DioExceptionType.connectionError:
            errorMessage = 'Unable to connect to payment server. Please check your internet connection and try again.';
            break;
          case DioExceptionType.unknown:
            if (e.message?.contains('SocketException') == true ||
                e.message?.contains('Connection refused') == true ||
                e.message?.contains('Failed host lookup') == true) {
              errorMessage = 'Unable to connect to payment server. Please check your internet connection and try again.';
            } else {
              errorMessage = 'Network error: ${e.message ?? 'Unknown error occurred'}';
            }
            break;
          default:
            errorMessage = 'Network error: ${e.message ?? 'Unknown error occurred'}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Unexpected error occurred: ${e.runtimeType} - $e');
      
      // If it's already our custom exception, rethrow it
      if (e.toString().startsWith('Exception:')) {
        rethrow;
      }
      
      // Wrap other errors
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }
}