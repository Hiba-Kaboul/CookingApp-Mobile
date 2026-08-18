abstract class CategoryEvent {}

class GetCategoriesEvent extends CategoryEvent {
  final int cuisineId;

  GetCategoriesEvent(this.cuisineId);
}