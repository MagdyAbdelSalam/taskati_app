import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';

class EmptyTaskState extends StatelessWidget {
  const EmptyTaskState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Using a similar structure to our TaskatiLogo to build the fake placeholder lists securely
        SizedBox(
          height: 180.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 20.h,
                child: _buildMockTask(width: 200.w, isOutlined: true),
              ),
              Positioned(
                top: 70.h,
                right: 40.w,
                child: _buildMockTask(width: 220.w, isOutlined: false),
              ),
              Positioned(
                bottom: 20.h,
                left: 40.w,
                child: _buildMockTask(width: 200.w, isOutlined: false),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'You do not have any tasks yet!',
          style: AppTextStyles.subtitle.copyWith(
            color: AppColors.textMain,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Add new tasks to make your days productive.',
          textAlign: TextAlign.center,
          style: AppTextStyles.subtitle.copyWith(
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildMockTask({required double width, required bool isOutlined}) {
    return Container(
      width: width,
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: isOutlined ? Border.all(color: AppColors.primary.withAlpha(50)) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Icon(Icons.close, color: Colors.white, size: 16.sp), // Mocking the 'X' inside check icon
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                width: 70.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
