import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_flutter/data/repository/local/local_data_access.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper implements LocalDataAccess {
  final SharedPreferences sharedPref;
  late final secureStorage = const FlutterSecureStorage();

  SharedPrefHelper(this.sharedPref);

  @override
  Future clearAccessToken() async {
    return await secureStorage.delete(key: 'accessToken');
  }

  @override
  Future clearRefreshToken() async {
    return await secureStorage.delete(key: 'refreshToken');
  }

  @override
  Future<String> getAccessToken() async {
    return await secureStorage.read(key: 'accessToken') ?? '';
  }

  @override
  Future<String> getIDToken() async {
    return await secureStorage.read(key: 'idToken') ?? '';
  }

  @override
  Future<String> getRefreshToken() async {
    return await secureStorage.read(key: 'refreshToken') ?? '';
  }

  @override
  Future setAccessToken(String accessToken) async {
    await secureStorage.write(key: 'accessToken', value: accessToken);
  }

  @override
  Future setIDToken(String idToken) async {
    await secureStorage.write(key: 'idToken', value: idToken);
  }

  @override
  Future setRefreshToken(String refreshToken) async {
    await secureStorage.write(key: 'refreshToken', value: refreshToken);
  }
}
