class EditProfileModel {
  final String? name;
  final String? bio;
  final String? language;
  final String? theme;

  EditProfileModel({
    this.name,
    this.bio,
    this.language,
    this.theme,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "bio": bio,
      "language": language,
      "theme": theme,
    };
  }
}