import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';
import '../../home/screen/home_screen.dart';
import '../modules/cubit/auth_cubit.dart';
import '../modules/cubit/auth_state.dart';
import '../modules/data/auth_repository.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(AuthRepository()),
      child: const AuthView(),
    );
  }
}

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final TextEditingController _nameController = TextEditingController();
  String? _currentImagePath;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    return Scaffold(
      appBar: AppBar(
        
        elevation: 0,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthSuccess) {
            
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile saved successfully!')),
            );
          } else if (state is AuthImageSelected) {
            setState(() {
              _currentImagePath = state.imagePath;
            });
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 60.h),
                  _buildAvatar(),
                  SizedBox(height: 24.h),
                  _buildUploadButton(
                    'Upload From Camera',
                    () => cubit.pickImage(ImageSource.camera),
                  ),
                  SizedBox(height: 16.h),
                  _buildUploadButton(
                    'Upload From Gallery',
                    () => cubit.pickImage(ImageSource.gallery),
                  ),
                  SizedBox(height: 40.h),
                  Divider(
                    color: Colors.grey[300],
                    thickness: 1,
                  ),
                  SizedBox(height: 40.h),
                  _buildNameField(),
                  SizedBox(height: 40.h),
                  _buildUploadButton('Done', () => cubit.saveProfile(_nameController.text)),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 60.r,
      backgroundColor: const Color(0xFF333333),
      backgroundImage: _currentImagePath != null ? FileImage(File(_currentImagePath!)) : null,
      child: _currentImagePath == null
          ? Icon(
              Icons.person,
              size: 80.r,
              color: AppColors.primary,
            )
          : null,
    );
  }

  Widget _buildUploadButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTextStyles.buttonText.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        hintText: 'Enter your name',
        hintStyle: AppTextStyles.subtitle.copyWith(
          color: Colors.grey[600],
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2.w,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      ),
    );
  }
}
