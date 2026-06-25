import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/features/setting/presentation/bloc/settings_bloc.dart';
import 'package:project2/features/setting/presentation/bloc/settings_state.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/profile_title.dart';
import '../widgets/stack_profile.dart';
import '../widgets/taps.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "المعلومات الشخصية",
              style: AppTextStyles.appBarTitle,
            ),
          ),
        ),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
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

            return Column(
              children: [
                Profiletop(imageUrl: user.avatar ?? ""),
                const SizedBox(height: 40),
                ProfileTitle(
                  name: user.name,
                  bio: user.bio ?? "",
                  title: user.email ?? "",
                  posts_count: user.posts_count,
                ),
                const Expanded(child: Taps()),
              ],
            );
          }
          return Container(
            color: Colors.cyan,
          );
        },
      ),
    );
  }
}
