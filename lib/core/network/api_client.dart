import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../errors/exceptions.dart';
import '../utils/secure_storage.dart';

class ApiClient {
  final http.Client _client;
  final SecureStorage _secureStorage;

  ApiClient({
    required http.Client client,
    required SecureStorage secureStorage,
  })  : _client = client,
        _secureStorage = secureStorage;

  // GET request
  Future<dynamic> get(String endpoint) async {
    try {
      final token = await _secureStorage.getToken();
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: {
          ApiConstants.contentType: ApiConstants.applicationJson,
          if (token != null) ApiConstants.authorization: '${ApiConstants.bearer} $token',
        },
      );

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // POST request
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final token = await _secureStorage.getToken();
      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: {
          ApiConstants.contentType: ApiConstants.applicationJson,
          if (token != null) ApiConstants.authorization: '${ApiConstants.bearer} $token',
        },
        body: body != null ? json.encode(body) : null,
      );

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // Handle response
  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(response.body);
      case 400:
        throw ServerException('Bad request: ${response.body}');
      case 401:
      case 403:
        throw AuthException('Authentication failed: ${response.body}');
      case 404:
        throw ServerException('Resource not found: ${response.body}');
      case 500:
      default:
        throw ServerException('Server error: ${response.statusCode}');
    }
  }
}
