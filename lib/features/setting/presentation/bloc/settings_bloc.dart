import 'package:bloc/bloc.dart';
import 'package:project2/core/utils/token_storage.dart';
import '../../data/api/settings_api.dart';
import 'settings_event.dart';
import 'settings_state.dart';



class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsApi api;

  SettingsBloc(this.api) : super(SettingsInitial()) {
    on<GetProfileEvent>(_getProfile);
  }

  Future<void> _getProfile(
    GetProfileEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());

    try {
      final token = await TokenStorage.getToken();

      if (token == null) {
        emit(SettingsError('Token Not Found'));
        return;
      }

      final response = await api.getUserInfo(
        
      );

      emit(SettingsLoaded(response.data));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
}