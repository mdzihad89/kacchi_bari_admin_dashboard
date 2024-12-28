
import 'package:shared_preferences/shared_preferences.dart';

const String tokenKey = "token";

class AppPreferences {
  final SharedPreferencesWithCache _sharedPreferencesWithCache;

  AppPreferences(this._sharedPreferencesWithCache);

  Future<void> saveCredential(String token) async {
    await _sharedPreferencesWithCache.setString(tokenKey, token);
  }

  String? getCredential() {
    return _sharedPreferencesWithCache.getString(tokenKey) ;
  }

  Future<void> removeCredential() async {
    _sharedPreferencesWithCache.remove(tokenKey);
  }
}
