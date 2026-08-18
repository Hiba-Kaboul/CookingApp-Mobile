// import 'package:flutter/material.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/utils/token_storage.dart';
// import '../../../main_navigation/presentation/pages/main_navigation_page.dart';
// import '../../../onboarding/presentation/pages/onboarding_page.dart';

// class SplashPage extends StatefulWidget {
//   const SplashPage({super.key});

//   @override
//   State<SplashPage> createState() => _SplashPageState();
// }

// class _SplashPageState extends State<SplashPage> {
//   @override
//   void initState() {
//     super.initState();
//     _checkAppState();
//   }

//   Future<void> _checkAppState() async {
//     final isLoggedIn = await TokenStorage.isLoggedIn();

//     if (!mounted) return;

//     Widget nextPage = isLoggedIn
//         ? const MainNavigationPage()
//         : const OnboardingPage();

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => nextPage),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: AppColors.background,
//       body: Center(
//         child: CircularProgressIndicator(color: AppColors.primary),
//       ),
//     );
//   }
// }
////////////////////////////////////////////////////////////////////
import 'package:flutter/material.dart';
import 'package:project2/features/auth/presentation/pages/login_page.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/token_storage.dart';
import '../../../auth/data/auth_api.dart';
import '../../../main_navigation/presentation/pages/main_navigation_page.dart';
import '../../../notification/data/fcm_service.dart';
import '../../../onboarding/presentation/pages/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthApi _authApi = AuthApi();

  @override
  void initState() {
    super.initState();
    _checkAppState();
  }

  Future<void> _checkAppState() async {
    final isLoggedIn = await TokenStorage.isLoggedIn();

    if (!mounted) return;

    Widget nextPage;

    if (isLoggedIn) {
      final token = await TokenStorage.getToken();
      final newToken = await _refreshToken(token!);

      if (newToken != null) {
        await TokenStorage.updateToken(newToken);
        await FcmService.registerToken();
        nextPage = const MainNavigationPage();
      } else {
        await TokenStorage.clearSession();
        nextPage = const LoginPage();
        /////////////////////////////////////
      }
    } else {
      nextPage = const OnboardingPage();
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextPage),
    );

    if (nextPage is MainNavigationPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FcmService.openPendingNotification();
      });
    }
  }

  Future<String?> _refreshToken(String token) async {
    try {
      final result = await _authApi.refreshToken(token: token);
      return result.accessToken;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}