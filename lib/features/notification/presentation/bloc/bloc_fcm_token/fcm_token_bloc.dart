import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/fcm_token_api.dart';
import 'fcm_token_event.dart';
import 'fcm_token_state.dart';

class FcmTokenBloc extends Bloc<FcmTokenEvent, FcmTokenState> {
  final FcmTokenApi api;

  FcmTokenBloc(this.api) : super(FcmTokenInitial()) {
    on<UpdateFcmTokenEvent>(_onUpdateFcmToken);
  }

  Future<void> _onUpdateFcmToken(
    UpdateFcmTokenEvent event,
    Emitter<FcmTokenState> emit,
  ) async {
    emit(FcmTokenLoading());

    try {
      await api.updateFcmToken(event.fcmToken);
      emit(FcmTokenSuccess());
    } catch (e) {
      emit(FcmTokenError("تعذر تحديث توكن الإشعارات"));
    }
  }
}
