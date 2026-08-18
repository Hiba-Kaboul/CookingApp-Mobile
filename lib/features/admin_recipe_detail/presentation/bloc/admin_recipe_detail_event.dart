abstract class AdminRecipeDetailEvent {}

class GetAdminRecipeDetail extends AdminRecipeDetailEvent {
  final int id;

  GetAdminRecipeDetail(this.id);
}
