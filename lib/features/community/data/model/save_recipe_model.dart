class SaveRecipe {
  final bool saved;
  final int savesCount;

  SaveRecipe({required this.saved, required this.savesCount});

  factory SaveRecipe.fromMap(Map<String, dynamic> map) {
    final data = map['data'];
    return SaveRecipe(
      saved: data['saved'] ?? false,
      savesCount: data['saves_count'] ?? 0,
    );
  }
}