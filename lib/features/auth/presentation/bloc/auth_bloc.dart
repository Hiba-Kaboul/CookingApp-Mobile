import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/auth_api.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthApi _api = AuthApi();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '70674170260-8leo7ijs6k4paqgclo0rijciib1bn8h5.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );
  AuthBloc() : super(AuthInitial()) {
    on<RegisterSubmitted>(_onRegister);
    on<VerifyOtpSubmitted>(_onVerifyOtp);
    on<ResendOtpRequested>(_onResendOtp);
    on<LoginSubmitted>(_onLogin);
    on<LogoutRequested>(_onLogout);
    on<ForgotPasswordSubmitted>(_onForgotPassword);
    on<ResetPasswordSubmitted>(_onResetPassword);
    on<ResetPasswordWithOtpSubmitted>(_onResetPasswordWithOtp);
    on<ResendForgotPasswordOtp>(_onResendForgotPasswordOtp);
    on<GoogleSignInSubmitted>(_onGoogleSignIn);
  }

  Future<void> _onRegister(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _api.register(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      emit(RegisterSuccess(event.email));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _api.verifyEmail(email: event.email, code: event.code);
      emit(VerifyOtpSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onResendOtp(
    ResendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _api.resendVerification(email: event.email);
      emit(ResendOtpSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLogin(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _api.login(
        email: event.email,
        password: event.password,
      );

      emit(LoginSuccess(
        token: result.data.accessToken,
        name: result.data.user.name,
         email: result.data.user.email, 
      ));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _api.logout(token: event.token);
      emit(LogoutSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception', '')));
    }
  }

  Future<void> _onForgotPassword(
      ForgotPasswordSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _api.forgotPassword(email: event.email);
      emit(ForgetPasswordSuccess(event.email));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception:', "")));
    }
  }

  Future<void> _onResetPassword(
      ResetPasswordSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _api.resetPassword(
          email: event.email,
          code: event.code,
          password: event.password,
          passwordConfirmation: event.passwordConfirmation);
      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception', "")));
    }
  }

  Future<void> _onResetPasswordWithOtp(
    ResetPasswordWithOtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _api.resetPassword(
        email: event.email,
        code: event.code,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
      );
      emit(ResetPasswordWithOtpSuccess());
    } catch (e) {
      final message = e.toString().replaceAll('Exception: ', '').toLowerCase();
      if (message.contains('verification code is invalid') ||
          message.contains('invalid')) {
        emit(AuthFailure('رمز التحقق غير صحيح'));
      } else if (message.contains('at least 8') ||
          message.contains('password')) {
        emit(AuthFailure('كلمة المرور يجب أن تكون 8 أحرف على الأقل'));
      } else {
        emit(AuthFailure('حدث خطأ، حاول مجدداً'));
      }
    }
  }

  Future<void> _onResendForgotPasswordOtp(
    ResendForgotPasswordOtp event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _api.forgotPassword(email: event.email);
      emit(ResendOtpSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
////////////////////////////////////////////////
  Future<void> _onGoogleSignIn(
    GoogleSignInSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // 1. فتح نافذة جوجل
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(AuthFailure('تم إلغاء تسجيل الدخول'));
        return;
      }

      // 2. استخراج الـ id_token
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        emit(AuthFailure('فشل في الحصول على رمز الأمان من جوجل'));
        return;
      }

      // 3. إرسال التوكن إلى Laravel (عبر ملف الـ API)
      final result = await _api.loginWithGoogle(idToken: idToken);

      // 4. في حال نجاح الباك اند، نطلق نفس الـ State الخاص باللوجين العادي
      emit(LoginSuccess(
        token: result.data.accessToken,
        name: result.data.user.name,
         email: result.data.user.email, 
      ));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
