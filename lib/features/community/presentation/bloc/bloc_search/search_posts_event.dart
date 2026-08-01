abstract class SearchPostsEvent {}

class SearchPostsQueryChanged extends SearchPostsEvent {
  final String query;
  SearchPostsQueryChanged(this.query);
}