import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Save a simple string value
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Read a simple string value
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // Delete a value
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  // Save an object (must be JSON serializable)
  Future<void> writeObject<T>(
      String key, T object, String Function(T) toJson) async {
    final jsonString = toJson(object);
    await _storage.write(key: key, value: jsonString);
  }

  // Read an object (must provide fromJson)
  Future<T?> readObject<T>(
      String key, T Function(Map<String, dynamic>) fromJson) async {
    final jsonString = await _storage.read(key: key);
    if (jsonString == null) return null;
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return fromJson(jsonMap);
  }

  // Delete all values
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
