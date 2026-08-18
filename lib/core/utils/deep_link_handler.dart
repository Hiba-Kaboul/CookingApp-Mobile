import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/features/admin_recipe_detail/data/api/admin_recipe_detail_api.dart';
import 'package:project2/features/admin_recipe_detail/presentation/bloc/admin_recipe_detail_bloc.dart';
import 'package:project2/features/admin_recipe_detail/presentation/pages/admin_recipe_detail_page.dart';
import 'package:project2/features/recipe_detail/data/api/recipe_detail_api.dart';
import 'package:project2/features/recipe_detail/presentation/bloc/recipe_detail_bloc.dart';
import 'package:project2/features/recipe_detail/presentation/pages/recipe_detail_page.dart';

class DeepLinkHandler {
  DeepLinkHandler._();

  static final AppLinks _appLinks = AppLinks();

  static void listen(GlobalKey<NavigatorState> navigatorKey) {
    _appLinks.uriLinkStream.listen((uri) {
      openFromUri(uri, navigatorKey);
    });

    _appLinks.getInitialLink().then((uri) async {
      if (uri == null) return;
      await Future.delayed(const Duration(milliseconds: 800));
      openFromUri(uri, navigatorKey);
    });
  }

  static void openFromUri(Uri uri, GlobalKey<NavigatorState> navigatorKey) {
    if (uri.scheme != 'cookingapp') return;
    if (uri.pathSegments.isEmpty) return;

    final type = uri.host;
    final id = int.tryParse(uri.pathSegments.first);
    if (id == null) return;

    if (type == 'posts') {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => RecipeDetailBloc(RecipeDetailApi()),
            child: RecipeDetailPage(id: id),
          ),
        ),
      );
    } else if (type == 'recipes') {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AdminRecipeDetailBloc(AdminRecipeDetailApi()),
            child: AdminRecipeDetailPage(id: id),
          ),
        ),
      );
    }
  }
}