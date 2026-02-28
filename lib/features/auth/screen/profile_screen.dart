import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/app_colors.dart';
import '../../../../taskati_app.dart';
import '../modules/data/auth_repository.dart';

/// Profile / Edit Screen — matches the mockup:
///  • Profile picture centred with a camera icon overlay
///  • Tapping the picture shows a bottom sheet with camera / gallery options
///  • Name shown below with a pencil icon to inline-edit it
///  • Dark mode sun/moon toggle in the AppBar
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authRepo = AuthRepository();
  final _nameController = TextEditingController();
  final _picker = ImagePicker();

  String? _imagePath;
  bool _editingName = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = _authRepo.getUserName() ?? '';
    _imagePath = _authRepo.getUserImagePath();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ─── Image Picking ───────────────────────────────────────────────────────────

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context); // Close bottom sheet
    final picked = await _picker.pickImage(source: source, imageQuality: 80);
    if (picked == null) return;
    await _authRepo.saveUserProfile(_nameController.text, picked.path);
    setState(() => _imagePath = picked.path);
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 24.h),
            _sheetButton(
              label: 'Upload from Camera',
              onTap: () => _pickImage(ImageSource.camera),
            ),
            SizedBox(height: 12.h),
            _sheetButton(
              label: 'Upload from Gallery',
              onTap: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetButton({required String label, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ─── Name Saving ─────────────────────────────────────────────────────────────

  Future<void> _saveName() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    await _authRepo.saveUserProfile(name, _imagePath ?? '');
    setState(() => _editingName = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated!'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ─── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = themeNotifier.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.primary, size: 20.r),
          onPressed: () => Navigator.pop(context, true), // true = refresh home
        ),
        actions: [
          // Dark / Light mode toggle
          IconButton(
            icon: Icon(
              isDark ? Icons.wb_sunny_outlined : Icons.wb_sunny,
              color: AppColors.primary,
              size: 28.r,
            ),
            onPressed: () {
              themeNotifier.value =
                  isDark ? ThemeMode.light : ThemeMode.dark;
              setState(() {}); // Refresh icon
            },
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 60.h),

          // ── Profile Picture ──────────────────────────────────────────────
          Center(
            child: GestureDetector(
              onTap: _showImageSourceSheet,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 65.r,
                    backgroundColor: AppColors.primary.withAlpha(30),
                    backgroundImage: _imagePath != null && _imagePath!.isNotEmpty
                        ? FileImage(File(_imagePath!))
                        : null,
                    child: (_imagePath == null || _imagePath!.isEmpty)
                        ? Icon(Icons.person, color: AppColors.primary, size: 60.r)
                        : null,
                  ),
                  // Camera badge
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 2,
                        ),
                      ),
                      child: Icon(Icons.camera_alt, color: Colors.white, size: 16.r),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 40.h),
          Divider(color: AppColors.primary.withAlpha(80), indent: 24.w, endIndent: 24.w),
          SizedBox(height: 20.h),

          // ── Name Row ─────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: _editingName
                ? Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          autofocus: true,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your name',
                          ),
                          onSubmitted: (_) => _saveName(),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.check, color: AppColors.primary),
                        onPressed: _saveName,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Text(
                          _nameController.text.isEmpty ? 'Tap to set name' : _nameController.text,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _editingName = true),
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary, width: 1.5),
                          ),
                          child: Icon(Icons.edit_outlined, color: AppColors.primary, size: 18.r),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
