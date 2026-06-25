
import '../../data/models/settings_model.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final ProfileData profile;

  SettingsLoaded(this.profile);
}

class SettingsError extends SettingsState {
  final String message;

  SettingsError(this.message);
}