import 'dart:io';

abstract class EditProfileEvent {}

class UpdateProfileEvent extends EditProfileEvent {
  final String name;
  final String bio;
  final String language;
  final String theme;
  final File? image;

  UpdateProfileEvent({
    required this.name,
    required this.bio,
    required this.language,
    required this.theme,
    this.image,
  });
}