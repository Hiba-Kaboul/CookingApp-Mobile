import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/features/setting/presentation/pages/settings_page.dart';
import 'package:project2/features/splash/presentation/pages/splash_page.dart';
import '../../../onboarding/presentation/pages/onboarding_page.dart';
import '../../../setting/data/api/settings_api.dart';
import '../../../setting/presentation/bloc/settings_bloc.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int currentIndex = 0;

  // تحويل القائمة إلى Getter
  List<Widget> get pages => [
        Center(
          child: Column(
            children: [
              const Text('Home Page'),
              IconButton(
                onPressed: () {
                  // الآن يمكن الوصول إلى context بنجاح
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const OnboardingPage()),
                  );
                }, 
                icon: const Icon(Icons.abc),
              )
            ],
          ),
        ),
        const Center(child: Text('Search Page')),
        const Center(child: Text('Add Recipe Page')),
        const Center(child: Text('Favorites Page')),
        BlocProvider(
          create: (_) => SettingsBloc(SettingsApi()),
          child: const SettingsPage(),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // استدعاء الـ getter هنا
      body: pages[currentIndex], 
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
