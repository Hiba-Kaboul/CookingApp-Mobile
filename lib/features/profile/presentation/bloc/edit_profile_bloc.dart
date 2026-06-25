import 'package:flutter_bloc/flutter_bloc.dart';
import 'edit_profile_state.dart';
import '../../data/api/edit_profile_api.dart';
import 'settings_event.dart';

class EditProfileBloc
    extends Bloc<EditProfileEvent, EditProfileState> {
  final EditProfileApi api;

  EditProfileBloc(this.api)
      : super(EditProfileInitial()) {
    on<UpdateProfileEvent>(_updateProfile);
  }

  Future<void> _updateProfile(
    UpdateProfileEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(EditProfileLoading());

    try {
      final message = await api.updateProfile(
        name: event.name,
        bio: event.bio,
        language: event.language,
        theme: event.theme,
        image: event.image,
      );

      emit(EditProfileSuccess(message));
    } catch (e) {
      emit(EditProfileError(e.toString()));
    }
  }
}