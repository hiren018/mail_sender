import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final storage = const FlutterSecureStorage();
  static final instance = SecureStorage._internal();
  SecureStorage._internal();

  factory SecureStorage() {
    return instance;
  }

  Future setToken(String token) async {
    await storage.write(
        key: 'accessToken',
        value: token,
        aOptions: const AndroidOptions(
          encryptedSharedPreferences: true,
        ));
  }

  Future<String?> getUserToken() async {
    return await storage.read(key: 'accessToken', aOptions: const AndroidOptions(
          encryptedSharedPreferences: true,
        ));
  }

  Future setUserName(String name) async {
    await storage.write(
        key: 'userName',
        value: name,
        aOptions: const AndroidOptions(
          encryptedSharedPreferences: true,
        ));
  }

  Future<String?> getUserName() async {
    return await storage.read(key: 'userName', aOptions: const AndroidOptions(
          encryptedSharedPreferences: true,
        ));
  }

  Future setUserEmail(String mail) async {
    await storage.write(
        key: 'userEmail',
        value: mail,
        aOptions: const AndroidOptions(
          encryptedSharedPreferences: true,
        ));
  }

  Future<String?> getUserEmail() async {
    return await storage.read(
        key: 'userEmail',
        aOptions: const AndroidOptions(
          encryptedSharedPreferences: true,
        ));
  }
}
