import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_text_styles.dart';
import '../../data/change_password_api.dart';
import '../bloc/bloc_password/change_password_bloc.dart';
import '../bloc/bloc_password/change_password_event.dart';
import '../bloc/bloc_password/change_password_state.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordBloc(ChangePasswordApi()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text(
            'تغيير كلمة المرور',
            style: AppTextStyles.appBarTitle,
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.buttonText),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
                listener: (context, state) {
                  if (state is ChangePasswordSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.green,
                          content: Text("تم تغيير كلمة المرور بنجاح")),
                    );
                    Navigator.pop(context);
                  } else if (state is ChangePasswordFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: AppColors.primary,
                          content: Text("كلمة المرور الحالية غير مطابقة")),
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Center(
                        child: Image.asset(
                          "assets/images/changepassword.png",
                          width: MediaQuery.of(context).size.width * 0.8,
                        ),
                      ),
                      // const SizedBox(height: 20),
                      CustomTextField(
                        label: 'كلمة المرور الحالية',
                        hint: 'أدخل كلمة المرور الحالية',
                        suffixIcon: Icons.lock_outline,
                        isPassword: true,
                        controller: _oldPasswordController,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: 'كلمة المرور الجديدة',
                        hint: 'أدخل كلمة المرور الجديدة',
                        suffixIcon: Icons.lock_outline,
                        isPassword: true,
                        controller: _newPasswordController,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: 'تأكيد كلمة المرور',
                        hint: 'أعد إدخال كلمة المرور الجديدة',
                        suffixIcon: Icons.lock_outline,
                        isPassword: true,
                        controller: _confirmPasswordController,
                      ),
                      const SizedBox(height: 20),
                      state is ChangePasswordLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            )
                          : SizedBox(
                              width: double.infinity,
                              child: PrimaryButton(
                                text: 'حفظ',
                                onPressed: () {
                                  final oldPass =
                                      _oldPasswordController.text.trim();
                                  final newPass =
                                      _newPasswordController.text.trim();
                                  final confirmPass =
                                      _confirmPasswordController.text.trim();

                                  if (oldPass.isEmpty ||
                                      newPass.isEmpty ||
                                      confirmPass.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          backgroundColor: AppColors.primary,
                                          content:
                                              Text('يرجى تعبئة جميع الحقول')),
                                    );
                                    return;
                                  }

                                  if (newPass != confirmPass) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          backgroundColor: AppColors.primary,
                                          content: Text(
                                              'كلمتا المرور الجديدة غير متطابقتين')),
                                    );
                                    return;
                                  }

                                  context.read<ChangePasswordBloc>().add(
                                        ChangePasswordSubmitted(
                                          password: oldPass,
                                          newPassword: newPass,
                                          newPasswordConfirmation: confirmPass,
                                        ),
                                      );
                                },
                              ),
                            ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
