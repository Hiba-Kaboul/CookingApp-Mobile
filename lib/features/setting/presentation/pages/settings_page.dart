import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_text_styles.dart';
import 'package:project2/features/auth/data/auth_api.dart';
import '../widgets/profile_header.dart';
import '../widgets/settings_section_title.dart';
import '../widgets/settings_switch_tile.dart';
import '../widgets/settings_tile.dart';
import '../../../../core/utils/token_storage.dart';
import '../../../auth/presentation/pages/login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool appNotifications = true;
  bool newsletter = false;
  int currentNavIndex = 4;
  bool _isLoggingOut = false;
  final AuthApi _authApi = AuthApi();

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
    } catch (e) {
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
        elevation: 0,
        centerTitle: true,
        title: const Text('الإعدادات', style: AppTextStyles.appBarTitle),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          ProfileHeader(
            name: ' ميسي  ',
            subtitle: 'افضل لاعب بالتاريخ',
            imageUrl:
                'https://tse1.mm.bing.net/th/id/OIP.w7bL5m8OjpukFlr91wdRUAHaQD?rs=1&pid=ImgDetMain&o=7&rm=3',
            onEditTap: () {},
          ),
          const SizedBox(height: 20),
          const SettingsSectionTitle(title: 'الحساب'),
          _card([
            SettingsTile(
              title: 'المعلومات الشخصية',
              icon: Icons.person_outline,
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder:(context) => ,))
              },
            ),
            const Divider(height: 1, color: AppColors.inputBorder),
            SettingsTile(
              title: 'الأمان وكلمة المرور',
              icon: Icons.lock_outline,
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder:(context) => ,))
              },
            ),
          ]),
          const SizedBox(height: 20),
          const SettingsSectionTitle(title: 'التفضيلات'),
          _card([
            SettingsTile(
              title: 'اللغة',
              icon: Icons.language,
              showChevron: false,
              trailingBadge: _languageBadge(),
              onTap: () {},
            ),
            const Divider(height: 1, color: AppColors.inputBorder),
            SettingsTile(
              title: 'المظهر',
              icon: Icons.palette_outlined,
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder:(context) => ,))
              },
            ),
          ]),
          const SizedBox(height: 20),
          const SettingsSectionTitle(title: 'الإشعارات'),
          _card([
            SettingsSwitchTile(
              title: 'إشعارات التطبيق',
              icon: Icons.notifications_none,
              value: appNotifications,
              onChanged: (v) => setState(() => appNotifications = v),
            ),
            const Divider(height: 1, color: AppColors.inputBorder),
            // SettingsSwitchTile(
            //   title: 'النشرة البريدية',
            //   icon: Icons.mail_outline,
            //   value: newsletter,
            //   onChanged: (v) => setState(() => newsletter = v),
            // ),
          ]),
          const SizedBox(height: 20),
          const SettingsSectionTitle(title: 'عام'),
          _card([
            SettingsTile(
              title: ' حول التطبيق',
              icon: Icons.help_outline,
              onTap: () {},
            ),
            const Divider(height: 1, color: AppColors.inputBorder),
            // SettingsTile(
            //   title: 'FlavorX',
            //   icon: Icons.info_outline,
            //   onTap: () {},
            // ),
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
          ], borderColor: AppColors.primary.withOpacity(0.3)),
        ],
      ),
    );
  }

  Widget _languageBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFD7E89A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'العربية',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _card(List<Widget> children, {Color? borderColor}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: borderColor != null ? Border.all(color: borderColor) : null,
        boxShadow: borderColor == null
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(children: children),
    );
  }
}
