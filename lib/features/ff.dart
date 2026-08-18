import 'package:flutter/material.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_text_styles.dart';

/// ====================================================================
/// شاشة تفاصيل الوصفة - سلطة الدجاج بالأعشاب البرية
/// التبويبات (التقييمات / الخطوات / المكونات) شغالة فعليًا:
/// الضغط على أي تبويب يبدّل المحتوى تحته.
/// ====================================================================
class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

enum _RecipeTab { reviews, steps, ingredients }

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool isFavorite = true;
  int servings = 4;
  _RecipeTab selectedTab = _RecipeTab.ingredients; // نفس الافتراضي بالتصميم

  final List<_Ingredient> ingredients = const [
    _Ingredient(
      name: 'صدور دجاج مشوية',
      amount: '500 جرام',
      color: AppColors.ResetPasswordBackgroundTextField,
    ),
    _Ingredient(
      name: 'خس بري طازج',
      amount: '2 كوب',
      color: AppColors.recipeCardYellow,
    ),
    _Ingredient(
      name: 'زيت زيتون بكر',
      amount: '3 ملاعق كبيرة',
      color: AppColors.recipeCardGreen,
    ),
    _Ingredient(
      name: 'جوز محمص',
      amount: '50 جرام',
      color: AppColors.ResetPasswordBackgroundTextField,
    ),
  ];

  final List<_Step> steps = const [
    _Step(
      number: '١',
      text:
          'ابدأ بتتبيل صدور الدجاج بالأعشاب البرية والملح والفلفل، ثم اتركها حتى تنضج تماماً وتكتسب لوناً ذهبياً.',
      cardColor: AppColors.ResetPasswordBackgroundTextField,
      circleColor: AppColors.primary,
    ),
    _Step(
      number: '٢',
      text:
          'في وعاء كبير، اخلط الخس البري الطازج مع زيت الزيتون البكر والفلفل ضمن عصير الليمون.',
      cardColor: AppColors.recipeCardYellow,
      circleColor: AppColors.textLight,
    ),
    _Step(
      number: '٣',
      text:
          'قطّع الدجاج المشوي إلى شرائح رفيعة وضعها فوق طبقة الخس، ثم زيّن بالجوز المحمص.',
      cardColor: AppColors.recipeCardGreen,
      circleColor: AppColors.recipeCircleGreen,
    ),
    _Step(
      number: '٤',
      text:
          'قدّم السلطة فوراً للاستمتاع بتناغم النكهات الريفية الدافئة مع الخضار المقرمشة.',
      cardColor: AppColors.ResetPasswordBackgroundTextField,
      circleColor: AppColors.primary,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTopImage(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 18),
                        _buildTitle(),
                        const SizedBox(height: 10),
                        _buildDescription(),
                        const SizedBox(height: 16),
                        _buildAuthorRow(),
                        const SizedBox(height: 16),
                        _buildStatsRow(),
                        const SizedBox(height: 18),
                        _buildTabsBar(),
                        const SizedBox(height: 20),
                        // === المحتوى المتغيّر حسب التبويب المختار ===
                        _buildTabContent(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomButton(),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // صورة الطبق العلوية + الأزرار الدائرية
  // ---------------------------------------------------------------------
  Widget _buildTopImage() {
    return AspectRatio(
      aspectRatio: 1.15,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              child: Container(
                color: AppColors.otpCardBackground,
                // ضع مسار صورتك هنا: Image.asset('assets/images/xxx.png')
                child: Image.network(
                  'https://images.unsplash.com/photo-1512621776951-a57141f2eefd',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.image, size: 60, color: AppColors.grey),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: _circleIconButton(
              icon: Icons.arrow_forward,
              onTap: () => Navigator.maybePop(context),
            ),
          ),
          Positioned(
            top: 16,
            left: 60,
            child: _circleIconButton(
              icon: Icons.ios_share_outlined,
              onTap: () {},
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: _circleIconButton(
              icon: isFavorite ? Icons.favorite : Icons.favorite_border,
              iconColor: AppColors.primary,
              onTap: () => setState(() => isFavorite = !isFavorite),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = AppColors.textDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.buttonText, // أبيض
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Icon(icon, size: 20, color: iconColor),
      ),
    );
  }

  // ---------------------------------------------------------------------
  Widget _buildTitle() {
    return const Text(
      'سلطة الدجاج بالأعشاب البرية',
      style: AppTextStyles.heading,
    );
  }

  Widget _buildDescription() {
    return Text(
      'وجبة صحية متكاملة غنية بالمكونات الريفية الأصلية، محضرة بعناية لتناسب ذائقتكم الرفيعة.',
      style: AppTextStyles.subHeading.copyWith(height: 1.6),
    );
  }

  // ---------------------------------------------------------------------
  // صف الشيف: زر متابعة + الاسم + الصورة
  // ---------------------------------------------------------------------
  Widget _buildAuthorRow() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.followButton,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            'متابعة',
            style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('سارة الحلبي', style: AppTextStyles.title),
            const SizedBox(height: 2),
            Text(
              'طبخ منزلي',
              style: AppTextStyles.subHeading.copyWith(fontSize: 11),
            ),
          ],
        ),
        const SizedBox(width: 10),
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.ResetPasswordBackgroundTextField,
          backgroundImage: const NetworkImage(
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
          ),
          onBackgroundImageError: (_, __) {},
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // صف الإحصائيات
  // ---------------------------------------------------------------------
  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _statPill(
            icon: Icons.local_fire_department_rounded,
            iconColor: AppColors.primary,
            label: '420 سعرة',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statPill(
            icon: Icons.people_alt_rounded,
            iconColor: AppColors.dotActive,
            label: '4 أشخاص',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statPill(
            icon: Icons.access_time_filled_rounded,
            iconColor: AppColors.light_brown,
            label: '35 دقيقة',
          ),
        ),
      ],
    );
  }

  Widget _statPill({
    required IconData icon,
    required Color iconColor,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.otpCardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.label),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // شريط التبويبات (فعّال: يبدّل _RecipeTab عند الضغط)
  // ---------------------------------------------------------------------
  Widget _buildTabsBar() {
    final tabs = {
      _RecipeTab.reviews: 'التقييمات',
      _RecipeTab.steps: 'الخطوات',
      _RecipeTab.ingredients: 'المكونات',
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: tabs.entries.map((entry) {
        final isSelected = entry.key == selectedTab;
        return GestureDetector(
          onTap: () => setState(() => selectedTab = entry.key),
          child: Column(
            children: [
              Text(
                entry.value,
                style: isSelected
                    ? AppTextStyles.title.copyWith(color: AppColors.primary)
                    : AppTextStyles.subHeading,
              ),
              const SizedBox(height: 6),
              Container(
                height: 3,
                width: 50,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ---------------------------------------------------------------------
  // يقرر أي محتوى يُعرض حسب التبويب المختار
  // ---------------------------------------------------------------------
  Widget _buildTabContent() {
    switch (selectedTab) {
      case _RecipeTab.ingredients:
        return _buildIngredientsSection();
      case _RecipeTab.steps:
        return _buildStepsSection();
      case _RecipeTab.reviews:
        return _buildReviewsSection();
    }
  }

  // ---------------------------------------------------------------------
  // قسم المكونات
  // ---------------------------------------------------------------------
  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIngredientsHeader(),
        const SizedBox(height: 14),
        ...ingredients.map(
          (ing) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildIngredientCard(ing),
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsHeader() {
    return Row(
      children: [
        _stepperButton(
          icon: Icons.remove,
          onTap: () {
            if (servings > 1) setState(() => servings--);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '$servings',
            style: AppTextStyles.title.copyWith(fontSize: 15),
          ),
        ),
        _stepperButton(
          icon: Icons.add,
          onTap: () => setState(() => servings++),
        ),
        const Spacer(),
        const Text('المكونات المطلوبة', style: AppTextStyles.heading),
      ],
    );
  }

  Widget _stepperButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.otpCardBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }

  Widget _buildIngredientCard(_Ingredient ingredient) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: ingredient.color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.buttonText, width: 2),
              color: AppColors.buttonText.withOpacity(0.35),
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(ingredient.name, style: AppTextStyles.title),
              const SizedBox(height: 4),
              Text(ingredient.amount, style: AppTextStyles.text14_400),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // قسم خطوات التحضير (الصورة الجديدة)
  // ---------------------------------------------------------------------
  Widget _buildStepsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepsHeader(),
        const SizedBox(height: 14),
        ...steps.map(
          (step) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildStepCard(step),
          ),
        ),
      ],
    );
  }

  Widget _buildStepsHeader() {
    return Row(
      children: [
        Container(
          width: 5,
          height: 22,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        const Text('خطوات التحضير', style: AppTextStyles.heading),
      ],
    );
  }

  Widget _buildStepCard(_Step step) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: step.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: step.circleColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              step.number,
              style: AppTextStyles.label.copyWith(
                color: AppColors.buttonText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              step.text,
              textAlign: TextAlign.right,
              style: AppTextStyles.text14_400.copyWith(
                color: AppColors.textDark,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // قسم التقييمات (بديل مبسّط، عدّليه لاحقاً حسب حاجتك)
  // ---------------------------------------------------------------------
  Widget _buildReviewsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Text(
        'لا توجد تقييمات بعد',
        style: AppTextStyles.subHeading,
      ),
    );
  }

  // ---------------------------------------------------------------------
  // زر "ابدأ الطبخ الذكي" الثابت
  // ---------------------------------------------------------------------
  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.auto_awesome, size: 20),
          label: Text('ابدأ الطبخ الذكي', style: AppTextStyles.button),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }
}

class _Ingredient {
  final String name;
  final String amount;
  final Color color;

  const _Ingredient({
    required this.name,
    required this.amount,
    required this.color,
  });
}

class _Step {
  final String number;
  final String text;
  final Color cardColor;
  final Color circleColor;

  const _Step({
    required this.number,
    required this.text,
    required this.cardColor,
    required this.circleColor,
  });
}