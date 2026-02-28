import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_colors.dart';
import '../app_text_styles.dart';

/// A reusable text form field used across the app.
/// Supports read-only mode (for date/time pickers), suffix icons,
/// multi-line input, and custom validators.
class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputType keyboardType;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.validator,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.subtitle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTextStyles.subtitle.copyWith(fontSize: 15.sp),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.subtitle.copyWith(
              color: Colors.grey[400],
              fontSize: 14.sp,
            ),
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary, width: 2.w),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
