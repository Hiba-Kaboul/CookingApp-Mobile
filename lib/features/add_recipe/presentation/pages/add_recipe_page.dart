import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/widgets/custom_text_field.dart';
import '../../data/models/create_post_request_model.dart';
import '../bloc/create_post_bloc.dart';
import '../bloc/create_post_event.dart';
import '../bloc/create_post_state.dart';
import '../bloc_categories/categories_bloc.dart';
import '../bloc_categories/categories_state.dart';
import '../widgets/CategorySelector.dart';
import '../widgets/multi_media_picker_v2.dart'; // 👈 استيراد جديد

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  // ---------- Controllers ----------
  final TextEditingController dishNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController cookTimeController = TextEditingController();
  final TextEditingController numberofpersonsController =
      TextEditingController();

  // ---------- State ----------
  // ❌ حذفنا: File? _pickedImage;
  List<RecipeMedia> _recipeMedia = []; // 👈 جديد: يخزن كل الصور والفيديوهات
  // القيمة الافتراضية المختارة كما بالتصميم

  int? selectedCategoryId;
  // كل مكوّن = (اسم، كمية) لذلك نستخدم قائمة من أزواج Controllers
  final List<Map<String, TextEditingController>> _ingredients = [
    {
      'name': TextEditingController(),
      'amount': TextEditingController(),
    },
  ];

  // كل خطوة = نص واحد
  final List<TextEditingController> _steps = [
    TextEditingController(),
  ];

  // ❌ حذفنا: Future<void> _pickImage() async {...}
  // لأنو صار الاختيار كامل جوا MultiMediaPicker نفسه

  void _addIngredient() {
    setState(() {
      _ingredients.add({
        'name': TextEditingController(),
        'amount': TextEditingController(),
      });
    });
  }

  void _removeIngredient(int index) {
    setState(() => _ingredients.removeAt(index));
  }

  void _addStep() {
    setState(() => _steps.add(TextEditingController()));
  }

  void _removeStep(int index) {
    setState(() => _steps.removeAt(index));
  }

  @override
  void dispose() {
    dishNameController.dispose();
    descriptionController.dispose();
    cookTimeController.dispose();
    numberofpersonsController.dispose();
    for (final ing in _ingredients) {
      ing['name']!.dispose();
      ing['amount']!.dispose();
    }
    for (final step in _steps) {
      step.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePostBloc, CreatePostState>(
        listener: (context, state) {
      if (state is CreatePostSuccess) {
        dishNameController.clear();
        descriptionController.clear();
        cookTimeController.clear();
        numberofpersonsController.clear();

        for (final ingredient in _ingredients) {
          ingredient['name']!.clear();
          ingredient['amount']!.clear();
        }

        for (final step in _steps) {
          step.clear();
        }

        setState(() {
          _recipeMedia.clear();
          selectedCategoryId = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("تم إنشاء المنشور بنجاح. في انتظار الموافقة."),
          ),
        );
      }

      if (state is CreatePostError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(state.message),
          ),
        );
      }
    }, builder: (context, state) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.buttonText, // خلفية فاتحة كما التصميم
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppColors.primary,
            centerTitle: true,
            title: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'إضافة وصفة',
                  style: AppTextStyles.appBarTitle,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 👇 هون بالضبط مكان الاستدعاء - استبدلنا _buildImagePicker()
                MultiMediaPicker(
                  onChanged: (mediaList) {
                    setState(() => _recipeMedia = mediaList);
                  },
                ),
                const SizedBox(height: 20),
                _sectionTitle('تفاصيل الوصفة'),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'اسم الطبق',
                  hint: 'مثلاً: كبسة دجاج سعودية',
                  suffixIcon: Icons.restaurant_menu,
                  controller: dishNameController,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  label: 'وصف قصير',
                  hint: 'اكتب لنا سر نكهة هذا الطبق...',
                  suffixIcon: Icons.edit_note,
                  controller: descriptionController,
                ),
                const SizedBox(height: 20),
                _sectionTitle('الوقت و التصنيف'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'عدد الأشخاص',
                        hint: '4',
                        suffixIcon: Icons.timer_outlined,
                        controller: numberofpersonsController,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        label: 'وقت التحضير (دقيقة)',
                        hint: '30',
                        suffixIcon: Icons.timer_outlined,
                        controller: cookTimeController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  "التصنيفات :",
                  textAlign: TextAlign.right,
                  style: AppTextStyles.label,
                ),

                const SizedBox(height: 10),

                BlocBuilder<CategoriesBloc, CategoriesState>(
                  builder: (context, state) {
                    if (state is CategoriesLoading) {
                      return Center(child: const CircularProgressIndicator());
                    }

                    if (state is CategoriesSuccess) {
                      return CategorySelector(
                        categories: state.categories,
                        onSelected: (category) {
                          selectedCategoryId = category.id;
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
                const SizedBox(height: 8),

                const SizedBox(height: 20),
                _sectionTitleWithAction(
                  title: 'المكونات',
                  actionLabel: 'إضافة مكوّن',
                  onTap: _addIngredient,
                ),
                const SizedBox(height: 12),
                ..._buildIngredientsList(),
                const SizedBox(height: 20),
                _sectionTitleWithAction(
                  title: 'خطوات التحضير',
                  actionLabel: 'إضافة خطوة',
                  onTap: _addStep,
                ),
                const SizedBox(height: 12),
                ..._buildStepsList(),
                const SizedBox(height: 28),
                _buildPublishButton(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ---------------- أجزاء الواجهة ----------------

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: AppTextStyles.label.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _sectionTitleWithAction({
    required String title,
    required String actionLabel,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.add, size: 18, color: AppColors.primary),
          label: Text(
            actionLabel,
            style: const TextStyle(color: AppColors.primary, fontSize: 13),
          ),
        ),
        Text(
          title,
          style: AppTextStyles.label.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildIngredientsList() {
    return List.generate(_ingredients.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            if (_ingredients.length > 1)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.grey),
                onPressed: () => _removeIngredient(index),
              ),
            Expanded(
              child: CustomTextField(
                label: 'الكمية',
                hint: 'مثلاً: 500غ',
                suffixIcon: Icons.scale_outlined,
                controller: _ingredients[index]['amount']!,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomTextField(
                label: 'المكوّن',
                hint: 'اسم المكوّن',
                suffixIcon: Icons.eco_outlined,
                controller: _ingredients[index]['name']!,
              ),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _buildStepsList() {
    return List.generate(_steps.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_steps.length > 1)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.grey),
                onPressed: () => _removeStep(index),
              ),
            Expanded(
              child: TextField(
                controller: _steps[index],
                maxLines: 2,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  hintText: 'اكتب تفاصيل الخطوة رقم ${index + 1}...',
                  hintStyle: AppTextStyles.hint,
                  filled: true,
                  fillColor: AppColors.buttonText,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.inputBorder),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.primary,
              child: Text(
                '${index + 1}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPublishButton() {
    // هاد الزررررر يلي عم اشتغل عليه
    return ElevatedButton.icon(
      onPressed: () {
        final mediaFiles = _recipeMedia.map((e) => e.file).toList();

        final ingredients = _ingredients.map((ingredient) {
          return IngredientRequestModel(
            name: ingredient['name']!.text.trim(),
            quantity: ingredient['amount']!.text.trim(),
          );
        }).toList();

        final steps = List.generate(
          _steps.length,
          (index) => StepRequestModel(
            order: index + 1,
            description: _steps[index].text.trim(),
          ),
        );

        final request = CreatePostRequestModel(
          title: dishNameController.text.trim(),
          description: descriptionController.text.trim(),
          categoryId: selectedCategoryId!,
          durationMinutes: int.parse(cookTimeController.text),
          servings: int.parse(numberofpersonsController.text),
          steps: steps,
          ingredients: ingredients,
          media: mediaFiles,
        );
        if (selectedCategoryId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("اختر تصنيفاً أولاً"),
            ),
          );

          return;
        }
        context.read<CreatePostBloc>().add(
              CreatePostButtonPressed(
                request: request,
              ),
            );
      },
      icon: const Icon(Icons.send, size: 18, color: Colors.white),
      label: const Text(
        'نشر الوصفة',
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// ✅ ملاحظة: class DottedBorderBox انتقلت لداخل ملف multi_media_picker.dart
// ما عاد لازم تكون هون، فحذفناها من هاد الملف