import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dart:io';

import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String? imagePath;
  final VoidCallback onProfileTap;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.onProfileTap,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onProfileTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $userName',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.heading1.copyWith(
                    color: AppColors.primary,
                    fontSize: 24.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Have A Nice Day.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.subtitle.copyWith(
                    color: AppColors.textMain,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16.w),
        GestureDetector(
          onTap: onProfileTap,
          child: CircleAvatar(
            radius: 30.r, // Slightly larger avatar
            backgroundColor: AppColors.primary.withAlpha(50),
            backgroundImage: imagePath != null && imagePath!.isNotEmpty 
                ? FileImage(File(imagePath!)) 
                : null,
            child: (imagePath == null || imagePath!.isEmpty)
                ? Icon(Icons.person, color: AppColors.primary, size: 30.r)
                : null,
          ),
        ),
      ],
    );
  }
}
