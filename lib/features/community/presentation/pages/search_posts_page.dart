import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_text_styles.dart';

import '../../data/api/search_posts_api.dart';
import '../../data/model/search_post_model.dart';
import '../bloc_search/search_posts_bloc.dart';
import '../bloc_search/search_posts_event.dart';
import '../bloc_search/search_posts_state.dart';

class SearchPostsPage extends StatelessWidget {
  const SearchPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchPostsBloc(SearchPostsApi()),
      child: const _SearchPostsView(),
    );
  }
}

class _SearchPostsView extends StatefulWidget {
  const _SearchPostsView();

  @override
  State<_SearchPostsView> createState() => _SearchPostsViewState();
}

class _SearchPostsViewState extends State<_SearchPostsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          automaticallyImplyLeading: false,
          title: const Text(
            "صفحة البحث",
            style: AppTextStyles.appBarTitle,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward,
                  color: Colors.white), 
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: TextField(
                cursorColor: AppColors.primary,
                controller: _searchController,
                textAlign: TextAlign.right,
                style: AppTextStyles.label,
                decoration: InputDecoration(
                  hintText: 'ابحث عن وصفتك المفضلة',
                  hintStyle: AppTextStyles.hint,
                  filled: true,
                  fillColor: AppColors.buttonText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.inputBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.inputBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  prefixIcon:
                      const Icon(Icons.search, color: AppColors.grey, size: 26),
                ),
                onChanged: (value) {
                  context.read<SearchPostsBloc>().add(
                        SearchPostsQueryChanged(value),
                      );
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<SearchPostsBloc, SearchPostsState>(
                builder: (context, state) {
                  if (state is SearchPostsInitial) {
                    return const SizedBox.shrink();
                  }

                  if (state is SearchPostsLoading) {
                    return const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  if (state is SearchPostsError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: AppTextStyles.label,
                      ),
                    );
                  }

                  if (state is SearchPostsEmpty) {
                    return Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 100),
                        Card(
                          elevation: 20,
                          shadowColor: AppColors.primary,
                          child: Image.asset(
                            "assets/images/gg.png",
                            width: 200,
                            height: 200,
                            
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "لا يوجد نتائج",
                          style: AppTextStyles.names,
                        ),
                      ],
                    );
                  }

                  if (state is SearchPostsLoaded) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
                        itemCount: state.posts.length,
                        itemBuilder: (_, index) {
                          final post = state.posts[index];
                          return _PostSearchCard(post: post);
                        },
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostSearchCard extends StatelessWidget {
  final Post post;
  const _PostSearchCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final imageUrl = post.media.isNotEmpty ? post.media.first.url : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 6,
      shadowColor: AppColors.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColors.buttonText,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.inputBorder,
                image: imageUrl != null
                    ? DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(imageUrl),
                      )
                    : null,
              ),
              child: imageUrl == null
                  ? const Icon(Icons.image_not_supported, color: AppColors.grey)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: AppTextStyles.names,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        post.category.name,
                        style: AppTextStyles.title1,
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.access_time_rounded,
                          size: 18, color: AppColors.primary),
                      const SizedBox(width: 5),
                      Text(
                        "${post.durationMinutes} دقيقة",
                        style: AppTextStyles.subHeading,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
