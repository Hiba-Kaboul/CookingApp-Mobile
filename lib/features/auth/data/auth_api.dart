import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project2/features/auth/data/models/forgot_password_request_model.dart';
import 'package:project2/features/auth/data/models/forgot_password_response_model.dart';
import 'package:project2/features/auth/data/models/logout_response_model.dart';
import 'package:project2/features/auth/data/models/refresh_token_model.dart';
import 'package:project2/features/auth/data/models/reset_password_request_model.dart';
import 'package:project2/features/auth/data/models/reset_password_response_model.dart';
import 'models/register_request_model.dart';
import 'models/register_response_model.dart';
import 'models/verify_email_request_model.dart';
import 'models/verify_email_response_model.dart';
import 'models/resend_verification_request_model.dart';
import 'models/resend_verification_response_model.dart';
import 'models/login_request_model.dart';
import 'models/login_response_model.dart';
import 'models/refresh_token_model.dart';

class AuthApi {
  final String baseUrl = 'http://127.0.0.1:8000/api';
 // final String baseUrl = 'http://10.0.2.2:8000/api';

  // ───────── 1) Register ─────────
  Future<RegisterResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final request = RegisterRequestModel(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: password,
    );

    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    final json = jsonDecode(response.body);
    print(json);
    if (response.statusCode == 201) {
      print('REGISTER RESPONSE:');
      print(json);
      return RegisterResponseModel.fromJson(json);
    } else {
      final message = json['message']?.toString().toLowerCase() ?? '';

      if (message.contains('already been taken') ||
          message.contains('already taken')) {
        throw Exception('هذا الحساب موجود مسبقاً');
      }

      if (message.contains('at least 8')) {
        throw Exception('كلمة المرور يجب أن تكون 8 أحرف على الأقل');
      }

      throw Exception('حدث خطأ أثناء إنشاء الحساب');
    }
  }

  // ───────── 2) Verify Email (OTP) ─────────
  Future<VerifyEmailResponseModel> verifyEmail({
    required String email,
    required String code,
  }) async {
    print('EMAIL = $email');
    print('CODE = $code');
    final request = VerifyEmailRequestModel(email: email, code: code);
    print(jsonEncode(request.toMap()));
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-email'),
      headers: {'Content-Type': 'application/json'},
      body: request.toJson(),
      // body: jsonEncode(request.toJson()),
    );
    print(response.body);
    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return VerifyEmailResponseModel.fromJson(json);
    } else {
      throw Exception(json['message'] ?? 'رمز التحقق غير صحيح');
    }
  }

  // ───────── 3) Resend Verification ─────────
  Future<ResendVerificationResponseModel> resendVerification({
    required String email,
  }) async {
    final request = ResendVerificationRequestModel(email: email);

    final response = await http.post(
      Uri.parse('$baseUrl/auth/resend-verification'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return ResendVerificationResponseModel.fromJson(json);
    } else {
      throw Exception(json['message'] ?? 'تعذر إعادة إرسال الرمز');
    }
  }

  // ───────── 4) Login ─────────
  // Future<LoginResponseModel> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   final request = LoginRequestModel(email: email, password: password);

  //   final response = await http.post(
  //     Uri.parse('$baseUrl/auth/login'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode(request.toJson()),
  //   );

  //   final json = jsonDecode(response.body);

  //   if (response.statusCode == 200) {
  //     return LoginResponseModel.fromJson(json);
  //   } else {
  //     throw Exception('البريد الإلكتروني أو كلمة المرور غير صحيحة');
  //   }
  // }

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequestModel(email: email, password: password);

    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(json);
    } else if (response.statusCode == 403) {
      throw Exception('حسابك محظور، يرجى التواصل مع فريق الدعم');
    } else {
      throw Exception('البريد الإلكتروني أو كلمة المرور غير صحيحة');
    }
  }
// ───────── 5) Logout ─────────

  Future<LogoutResponseModel> logout({required String token}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return LogoutResponseModel.fromJson(json);
    } else {
      throw Exception(json['message'] ?? 'تعذر تسجيل الخروج');
    }
  }

// ───────── 6) Forgot Password ─────────

  Future<ForgotPasswordResponseModel> forgotPassword({
    required String email,
  }) async {
    final request = ForgotPasswordRequestModel(email: email);

    final response = await http.post(
      Uri.parse('$baseUrl/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return ForgotPasswordResponseModel.fromJson(json);
    } else {
      final message = json['message']?.toString().toLowerCase() ?? '';

      if (message.contains('please wait') ||
          message.contains('seconds before')) {
        final regex = RegExp(r'(\d+\.?\d*)');
        final match = regex.firstMatch(message);
        final seconds =
            match != null ? double.parse(match.group(1)!).ceil() : 60;
        throw Exception('يرجى الانتظار $seconds ثانية قبل طلب رمز جديد');
      }

      throw Exception('حدث خطأ أثناء إرسال الرمز');
    }
  }

// ───────── 7) Reset Password ─────────

  Future<ResetPasswordResponseModel> resetPassword({
    required String email,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    final request = ResetPasswordRequestModel(
      email: email,
      code: code,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    final response = await http.post(
      Uri.parse('$baseUrl/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return ResetPasswordResponseModel.fromJson(json);
    } else {
      throw Exception(
          json['message'] ?? 'حدث خطأ أثناء إعادة تعيين كلمة المرور');
    }
  }
////////////////////////////////////////////////////////////
// ───────── 6) Refresh Token ─────────

  Future<RefreshTokenResponseModel> refreshToken({
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/refresh'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return RefreshTokenResponseModel.fromJson(json);
    } else {
      throw Exception(json['message'] ?? 'انتهت صلاحية الجلسة');
    }
  }

//////////////////Google 
  Future<LoginResponseModel> loginWithGoogle({required String idToken}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/google'), // نفس الرابط اللي في البوست مان
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'id_token': idToken, // نفس المفتاح اللي في البوست مان
      }),
    );

    final json = jsonDecode(response.body);
    
    // إذا السيرفر رد بنجاح (200 أو 201)
    if (response.statusCode == 200 || response.statusCode == 201) {
      return LoginResponseModel.fromJson(json);
    } else {
      // إذا في خطأ من السيرفر (مثلاً التوكن مو صحيح)
      throw Exception(json['message'] ?? 'فشل تسجيل الدخول بحساب جوجل');
    }
  }




}
