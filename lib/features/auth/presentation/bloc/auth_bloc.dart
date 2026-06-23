import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/auth_api.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthApi _api = AuthApi();

  AuthBloc() : super(AuthInitial()) {
    on<RegisterSubmitted>(_onRegister);
    on<VerifyOtpSubmitted>(_onVerifyOtp);
    on<ResendOtpRequested>(_onResendOtp);
    on<LoginSubmitted>(_onLogin);
    on<LogoutRequested>(_onLogout);
    on<ForgotPasswordSubmitted>(_onForgotPassword);
    on<ResetPasswordSubmitted>(_onResetPassword);
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
      final result =
          await _api.login(email: event.email, password: event.password);
      emit(LoginSuccess(
        token: result.data.accessToken,
        name: result.data.user.name,
      ));
    } catch (e) {
      emit(AuthFailure(
          e.toString().replaceAll('Exception: ', "الحساب غير مسجل ")));
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
}
