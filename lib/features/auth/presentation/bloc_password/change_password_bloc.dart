import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/change_password_api.dart';
import 'change_password_event.dart';
import 'change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordApi api;

  ChangePasswordBloc(this.api) : super(ChangePasswordInitial()) {
    on<ChangePasswordSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    ChangePasswordSubmitted event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(ChangePasswordLoading());
    try {
      final result = await api.changePasswordApi(
        password: event.password,
        newPassword: event.newPassword,
        newPasswordConfirmation: event.newPasswordConfirmation,
      );
      emit(ChangePasswordSuccess(result.message));
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'حدث خطأ، حاول مرة أخرى';
      emit(ChangePasswordFailure(message.toString()));
    } catch (e) {
      emit(ChangePasswordFailure('حدث خطأ، حاول مرة أخرى'));
    }
  }
}