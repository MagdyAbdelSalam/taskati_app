import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../core/widgets/custom_text_form_field.dart';
import '../../home/modules/data/task_repository.dart';
import '../modules/cubit/add_task_cubit.dart';
import '../modules/cubit/add_task_state.dart';

// Task color palette — sourced from AppColors for consistency across screens
final List<Color> kTaskColors = AppColors.taskColors;

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddTaskCubit(TaskRepository()),
      child: const AddTaskView(),
    );
  }
}

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Populate date field with today's date from Cubit initial value
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<AddTaskCubit>();
      _dateController.text = cubit.formattedDate;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddTaskCubit, AddTaskState>(
      listener: (context, state) {
        if (state is AddTaskError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          );
        } else if (state is AddTaskSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Task created successfully!'),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          );
          Navigator.of(context).pop(true); // Return true to trigger refresh
        } else if (state is AddTaskFieldsUpdated) {
          // Sync controllers with cubit state
          _dateController.text = state.date;
          _startTimeController.text = state.startTime;
          _endTimeController.text = state.endTime;
        }
      },
      builder: (context, state) {
        final cubit = context.read<AddTaskCubit>();
        final selectedColorIndex = state is AddTaskFieldsUpdated
            ? state.selectedColorIndex
            : cubit.selectedColorIndex;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F7FF),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF8F7FF),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: AppColors.primary, size: 20.r),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Add Task',
              style: AppTextStyles.heading1.copyWith(
                color: AppColors.primary,
                fontSize: 20.sp,
              ),
            ),
            centerTitle: true,
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Title Field ---
                  CustomTextFormField(
                    controller: _titleController,
                    label: 'Title',
                    hintText: 'Enter title',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),

                  // --- Description / Note Field ---
                  CustomTextFormField(
                    controller: _noteController,
                    label: 'Description',
                    hintText: 'Enter description',
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                  ),
                  SizedBox(height: 20.h),

                  // --- Date Field ---
                  CustomTextFormField(
                    controller: _dateController,
                    label: 'Date',
                    hintText: 'Select date',
                    readOnly: true,
                    suffixIcon: Icon(Icons.calendar_month_outlined, color: AppColors.primary.withAlpha(150)),
                    onTap: () => cubit.selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Date is required';
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),

                  // --- Start & End Time Fields ---
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          controller: _startTimeController,
                          label: 'Start Time',
                          hintText: '09:00 AM',
                          readOnly: true,
                          suffixIcon: Icon(Icons.access_time_rounded, color: AppColors.primary.withAlpha(150)),
                          onTap: () => cubit.selectStartTime(context),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Required';
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: CustomTextFormField(
                          controller: _endTimeController,
                          label: 'End Time',
                          hintText: '10:00 AM',
                          readOnly: true,
                          suffixIcon: Icon(Icons.access_time_rounded, color: AppColors.primary.withAlpha(150)),
                          onTap: () => cubit.selectEndTime(context),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Required';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // --- Color Picker ---
                  Text(
                    'Color',
                    style: AppTextStyles.subtitle.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildColorPicker(context, cubit, selectedColorIndex),
                  SizedBox(height: 40.h),

                  // --- Create Task Button ---
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: 4,
                      ),
                      onPressed: state is AddTaskLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                cubit.saveTask(
                                  title: _titleController.text,
                                  note: _noteController.text,
                                );
                              }
                            },
                      child: state is AddTaskLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Create Task',
                              style: AppTextStyles.buttonText.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildColorPicker(BuildContext context, AddTaskCubit cubit, int selectedIndex) {
    return Wrap(
      spacing: 16.w,
      children: List.generate(kTaskColors.length, (index) {
        final isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () => cubit.selectColor(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: isSelected ? 48.w : 40.w,
            height: isSelected ? 48.w : 40.w,
            decoration: BoxDecoration(
              color: kTaskColors[index],
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: kTaskColors[index].withAlpha(150),
                        blurRadius: 12,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : null,
          ),
        );
      }),
    );
  }
}
