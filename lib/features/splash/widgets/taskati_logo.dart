import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/app_colors.dart';

class TaskatiLogo extends StatelessWidget {
  const TaskatiLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      constraints: BoxConstraints(minHeight: 150.h), 
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary,
          width: 3.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(26), 
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            // Top inner line
            Container(
              width: 60.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 12.h),
            _buildCheckmarkLine(),
            SizedBox(height: 8.h),
            _buildCheckmarkLine(),
            SizedBox(height: 8.h),
            _buildCheckmarkLine(),
            SizedBox(height: 8.h),
            _buildCheckmarkLine(),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckmarkLine() {
    return Row(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: AppColors.primary, width: 2.w),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Center(
            child: Icon(
              Icons.check,
              size: 14.w,
              color: AppColors.primary,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              width: 30.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
