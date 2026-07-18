import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/features/setting/presentation/bloc/settings_bloc.dart';
import 'package:project2/features/setting/presentation/bloc/settings_state.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../setting/data/api/settings_api.dart';
import '../../../setting/presentation/pages/settings_page.dart';
import '../widgets/profile_title.dart';
import '../widgets/stack_profile.dart';
import '../widgets/taps.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {},
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // 2. توفير الـ Bloc للصفحة المطلوبة
                      builder: (context) => BlocProvider(
                        create: (_) => SettingsBloc(SettingsApi()),
                        child: const SettingsPage(),
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.settings,
                  color: AppColors.buttonText,
                )),
            shadowColor: AppColors.primary,
            elevation: 10,
            backgroundColor: AppColors.primary,
            title: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "الملف الشخصي",
                  style: AppTextStyles.appBarTitle,
                ),
              ),
            ),
          ),
          body: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state is SettingsInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is SettingsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is SettingsError) {
                return Center(
                  child: Text(state.message),
                );
              }

              if (state is SettingsLoaded) {
                final user = state.profile;

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Profiletop(imageUrl: user.avatar ?? ""),
                      const SizedBox(height: 20),
                      ProfileTitle(
                        name: user.name,
                        bio: user.bio ?? "",
                        posts_count: user.posts_count,
                        title: "",
                        
                      ),
                      const SizedBox(
                        height:
                            500, // حددي الارتفاع المناسب لظهور التابات ومحتواها
                        child: Taps(),
                      ),
                    ],
                  ),
                );
              }
              return Container(
                color: Colors.cyan,
              );
            },
          ),
        ));
  }
}
