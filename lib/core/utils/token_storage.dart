import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _tokenKey = 'access_token';
  static const String _nameKey = 'user_name';
  static const String _emailKey = 'user_email';
    static const String _onboardingSeenKey = 'onboarding_seen';
  // حفظ بيانات الجلسة
  static Future<void> saveSession({
    required String token,
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_nameKey, name);
    await prefs.setString(_emailKey, email);
  }

  // قراءة التوكن
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // قراءة الاسم
  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

 // التحقق إذا في مستخدم مسجل دخول
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

static Future <void> setOnboardingSeen() async{
final prefs=await SharedPreferences.getInstance();
await prefs.setBool(_onboardingSeenKey,true);
}

static Future <bool> hasSeenOnboarding() async{
final prefs=await SharedPreferences.getInstance();
return prefs.getBool(_onboardingSeenKey)?? false ;
}

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_emailKey);
  }
}