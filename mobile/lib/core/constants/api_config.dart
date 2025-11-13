class ApiConfig {
  // Change this to your actual backend URL
  // For local development: 'http://localhost:8000/api' or 'http://10.0.2.2:8000/api' for Android emulator
  // For production: 'https://yourdomain.com/api'
  static const String baseUrl = 'http://10.28.5.188:8000/api';
  
  // Timeout configurations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}