import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';

class DateSlider extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DateSlider({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<DateSlider> createState() => _DateSliderState();
}

class _DateSliderState extends State<DateSlider> {
  final ScrollController _scrollController = ScrollController();
  late List<DateTime> _dates;

  @override
  void initState() {
    super.initState();
    _generateDates();
  }

  void _generateDates() {
    // Generate dates from today to 30 days ahead
    final today = DateTime.now();
    _dates = List.generate(30, (index) => today.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('MMMM dd, yyyy').format(widget.selectedDate),
          style: AppTextStyles.heading1.copyWith(fontSize: 22.sp),
        ),
        SizedBox(height: 4.h),
        Text(
          widget.selectedDate.day == DateTime.now().day &&
                  widget.selectedDate.month == DateTime.now().month &&
                  widget.selectedDate.year == DateTime.now().year
              ? 'Today'
              : DateFormat('EEEE').format(widget.selectedDate), // Show weekday if not Today
          style: AppTextStyles.heading2.copyWith(fontSize: 18.sp),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 100.h,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: _dates.length,
            itemBuilder: (context, index) {
              final date = _dates[index];
              final isSelected = date.day == widget.selectedDate.day &&
                  date.month == widget.selectedDate.month &&
                  date.year == widget.selectedDate.year;

              return GestureDetector(
                onTap: () => widget.onDateSelected(date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 70.w,
                  margin: EdgeInsets.only(right: 12.w),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('MMM').format(date).toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : AppColors.textMain,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppColors.textMain,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        DateFormat('E').format(date).toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : AppColors.textMain,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
