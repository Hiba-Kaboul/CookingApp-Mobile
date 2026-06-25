import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project2/core/constants/app_colors.dart';
import 'package:project2/core/constants/app_strings.dart';
import 'package:project2/core/constants/app_text_styles.dart';
import '../../../auth/presentation/widgets/primary_button.dart';
import '../../../setting/presentation/bloc/settings_bloc.dart';
import '../../../setting/presentation/bloc/settings_event.dart';
import '../../../setting/presentation/bloc/settings_state.dart';
import '../bloc/edit_profile_bloc.dart';
import '../bloc/edit_profile_state.dart';
import '../bloc/settings_event.dart';
import '../widgets/textform_fiels.dart';

class ProfileEditingPage extends StatefulWidget {
  const ProfileEditingPage({super.key});

  @override
  State<ProfileEditingPage> createState() => _ProfileEditingPageState();
}

class _ProfileEditingPageState extends State<ProfileEditingPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  File? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileSuccess) {
          context.read<SettingsBloc>().add(
                GetProfileEvent(),
              );

          Navigator.pop(context);
        }

        if (state is EditProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Padding(
            padding: EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'تعديل الملف الشخصي',
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

              if (_nameController.text.isEmpty) {
                _nameController.text = user.name;
              }

              if (_bioController.text.isEmpty) {
                _bioController.text = user.bio ?? '';
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _image != null
                              ? FileImage(_image!)
                              : (user.avatar != null && user.avatar!.isNotEmpty
                                  ? NetworkImage(user.avatar!)
                                  : null) as ImageProvider?,
                          child: (user.avatar == null || user.avatar!.isEmpty) &&
                                  _image == null
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.camera_alt,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        AppStrings.info,
                        style: AppTextStyles.otpTitle,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextformFiels(
                      controller: _nameController,
                      hint: user.name,
                      label:AppStrings.fullName ,
                    ),
                    const SizedBox(height: 15),
                    TextformFiels(
                      controller: _bioController,
                      hint: user.bio ?? "",
                      label: AppStrings.bio,
                    ),
                    const SizedBox(height: 40),
                    PrimaryButton(
                      text: "حفظ التعديلات",
                      onPressed: () {
                        context.read<EditProfileBloc>().add(
                              UpdateProfileEvent(
                                name: _nameController.text,
                                bio: _bioController.text,
                                language: user.language.value,
                                theme: user.theme.value,
                                image: _image,
                              ),
                            );
                      },
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}