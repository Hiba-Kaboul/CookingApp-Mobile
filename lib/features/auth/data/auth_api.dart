import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project2/features/auth/data/models/forgot_password_request_model.dart';
import 'package:project2/features/auth/data/models/forgot_password_response_model.dart';
import 'package:project2/features/auth/data/models/logout_response_model.dart';
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

class AuthApi {
  final String baseUrl = 'http://127.0.0.1:8000/api';

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

    if (response.statusCode == 201) {
      return RegisterResponseModel.fromJson(json);
    } else {
      throw Exception(json['message'] ?? 'حدث خطأ أثناء إنشاء الحساب');
    }
  }

  // ───────── 2) Verify Email (OTP) ─────────
  Future<VerifyEmailResponseModel> verifyEmail({
    required String email,
    required String code,
  }) async {
    final request = VerifyEmailRequestModel(email: email, code: code);

    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

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
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequestModel(email: email, password: password);

    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(json);
    } else {
      if (response.statusCode == 401 || response.statusCode == 422) {
        throw Exception('كلمة المرور غير صحيحة، حاول مجدداً');
      }
      throw Exception(json['message'] ?? 'البريد أو كلمة المرور غير صحيحة');
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
      throw Exception(json['message'] ?? 'حدث خطأ أثناء إرسال الرمز');
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
}
