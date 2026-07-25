import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/api/users_api.dart';
import '../../data/model/users_model.dart';
import 'users_posts_event.dart';
import 'users_posts_state.dart';

class UsersPostsBloc extends Bloc<UsersPostsEvent, UsersPostsState> {
  final UsersPostsApi api;

  List<PostModel> allPosts = [];
  int currentPage = 1;
  bool hasMore = true;
  bool isLoading = false;

  UsersPostsBloc(this.api) : super(UsersPostsInitial()) {
    on<GetUsersPostsEvent>(getPosts);
    on<LoadMorePostsEvent>(getPosts);
    on<UpdatePostLikeEvent>(updateLike);
    on<UpdatePostSaveEvent>(updateSave);
    on<UpdatePostCommentCountEvent>(updateCommentCount); 
  on<DecrementPostCommentCountEvent>(decrementCommentCount);
  }
  Future<void> getPosts(
    UsersPostsEvent event,
    Emitter<UsersPostsState> emit,
  ) 
  
  async {
    if (event is GetUsersPostsEvent) {
      currentPage = 1;
      allPosts = []; // تصفير القائمة عند الطلب الأول
      hasMore = true;
      emit(UsersPostsLoading());
    }

    if (isLoading || !hasMore) return;

    isLoading = true;
    try {
      final result = await api.getUsersPosts(currentPage);

      // الحل: إضافة فقط العناصر الجديدة التي ليست موجودة مسبقاً
      // نستخدم الـ ID للتأكد من عدم التكرار
      final newPosts = result.data
          .where((newPost) =>
              !allPosts.any((existingPost) => existingPost.id == newPost.id))
          .toList();

      allPosts.addAll(newPosts);

      hasMore = currentPage < result.meta.lastPage;
      if (hasMore) {
        currentPage++;
      }

      emit(UsersPostsSuccess(allPosts, hasMore));
    } catch (e) {
      emit(UsersPostsError(e.toString()));
    } finally {
      isLoading = false;
    }
  }


  void updateLike(
  UpdatePostLikeEvent event,
  Emitter<UsersPostsState> emit,
) {
  final index = allPosts.indexWhere((e) => e.id == event.postId);

  if (index == -1) return;

  allPosts[index].isLiked = event.isLiked;
  allPosts[index].likesCount = event.likesCount;

  emit(UsersPostsSuccess(
    List.from(allPosts),
    hasMore,
  ));
}
void updateSave(
  UpdatePostSaveEvent event, // تأكد أن هذا الحدث يمرر postId و isSaved
  Emitter<UsersPostsState> emit,
) {
  final index = allPosts.indexWhere((e) => e.id == event.postId);
  if (index == -1) return;

  allPosts[index].isSaved = event.isSaved; // تحديث حالة الحفظ

  emit(UsersPostsSuccess(List.from(allPosts), hasMore));
}

  void updateCommentCount(
    UpdatePostCommentCountEvent event,
    Emitter<UsersPostsState> emit,
  ) {
    final index = allPosts.indexWhere((e) => e.id == event.postId);
    if (index == -1) return;

    allPosts[index].commentsCount = allPosts[index].commentsCount + 1;

    emit(UsersPostsSuccess(List.from(allPosts), hasMore));
  }

void decrementCommentCount(
  DecrementPostCommentCountEvent event,
  Emitter<UsersPostsState> emit,
) {
  final index = allPosts.indexWhere((e) => e.id == event.postId);
  if (index == -1) return;

  if (allPosts[index].commentsCount > 0) {
    allPosts[index].commentsCount = allPosts[index].commentsCount - 1;
  }

  emit(UsersPostsSuccess(List.from(allPosts), hasMore));
}

}
