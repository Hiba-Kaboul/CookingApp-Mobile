import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_text_styles.dart';
import 'package:project2/features/profile/presentation/pages/profile_page.dart';
import '../../../profile/data/api/edit_profile_api.dart';
import '../../../profile/presentation/bloc/edit_profile_bloc.dart';
import '../../../profile/presentation/pages/profile_editing_page.dart';
import '../../data/api/settings_api.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/settings_section_title.dart';
import '../widgets/settings_switch_tile.dart';
import '../widgets/settings_tile.dart';
import '../../../../core/utils/token_storage.dart';
import '../../../auth/data/auth_api.dart';
import '../../../auth/presentation/pages/login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool appNotifications = true;
  bool newsletter = false;
  bool _isLoggingOut = false;

  final AuthApi _authApi = AuthApi();

  @override
  void initState() {
    super.initState();

    context.read<SettingsBloc>().add(
          GetProfileEvent(),
        );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoggingOut = true);

    try {
      final token = await TokenStorage.getToken();

      if (token != null && token.isNotEmpty) {
        await _authApi.logout(token: token);
      }
    } catch (_) {
    } finally {
      await TokenStorage.clearSession();

      if (!mounted) return;

      setState(() => _isLoggingOut = false);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'الإعدادات',
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

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                ProfileHeader(
                  name: user.name,
                  // email : user.email,
                  subtitle: user.email ?? '',
                  imageUrl: user.avatar ?? '',
                  onEditTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: context.read<SettingsBloc>(),
                            ),
                            BlocProvider(
                              create: (_) => EditProfileBloc(EditProfileApi()),
                            ),
                          ],
                          child: ProfileEditingPage(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const SettingsSectionTitle(
                  title: 'الحساب',
                ),
                _card([
                  SettingsTile(
                    title: 'المعلومات الشخصية',
                    icon: Icons.person_outline,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // 2. توفير الـ Bloc للصفحة المطلوبة
                          builder: (context) => BlocProvider(
                            create: (_) => SettingsBloc(SettingsApi())
                              ..add(
                                  GetProfileEvent()), // لا تنسَ إطلاق الحدث لجلب البيانات
                            child: const ProfilePage(),
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    title: 'الأمان وكلمة المرور',
                    icon: Icons.lock_outline,
                    onTap: () {},
                  ),
                ]),
                const SizedBox(height: 20),
                const SettingsSectionTitle(
                  title: 'التفضيلات',
                ),
                _card([
                  SettingsTile(
                    title: 'اللغة',
                    icon: Icons.language,
                    showChevron: false,
                    trailingBadge: _badge(
                      user.language.label,
                    ),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    title: 'المظهر',
                    icon: Icons.palette_outlined,
                    trailingBadge: _badge(
                      user.theme.label,
                    ),
                    onTap: () {},
                  ),
                ]),
                const SizedBox(height: 20),
                const SettingsSectionTitle(
                  title: 'الإشعارات',
                ),
                _card([
                  SettingsSwitchTile(
                    title: 'إشعارات التطبيق',
                    icon: Icons.notifications_none,
                    value: appNotifications,
                    onChanged: (v) {
                      setState(() {
                        appNotifications = v;
                      });
                    },
                  ),
                ]),
                const SizedBox(height: 20),
                const SettingsSectionTitle(
                  title: 'عام',
                ),
                _card([
                  SettingsTile(
                    title: 'حول التطبيق',
                    icon: Icons.help_outline,
                    onTap: () {},
                  ),
                ]),
                const SizedBox(height: 24),
                _card([
                  SettingsTile(
                    title: 'تسجيل الخروج',
                    icon: Icons.logout,
                    showChevron: false,
                    isDestructive: true,
                    onTap: () => _handleLogout(context),
                  ),
                ]),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFD7E89A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}
