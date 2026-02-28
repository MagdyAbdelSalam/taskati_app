import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../taskati_app.dart';
import '../../auth/modules/data/auth_repository.dart';
import '../../auth/screen/profile_screen.dart';
import '../../add_task/screen/add_task_screen.dart';
import '../modules/cubit/home_cubit.dart';
import '../modules/cubit/home_state.dart';
import '../modules/data/task_repository.dart';
import '../widgets/date_slider.dart';
import '../widgets/empty_task_state.dart';
import '../widgets/home_header.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(TaskRepository())..loadTasks(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final AuthRepository _authRepo;

  @override
  void initState() {
    super.initState();
    _authRepo = AuthRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: BlocConsumer<HomeCubit, HomeState>(
            listener: (context, state) {
              if (state is HomeError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is HomeInitial || state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is HomeLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Area with Dark Mode Toggle
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: HomeHeader(
                            userName: _authRepo.getUserName() ?? 'User',
                            imagePath: _authRepo.getUserImagePath(),
                            onProfileTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ProfileScreen()),
                              );
                              if (result == true) {
                                setState(() {}); // Refresh header
                              }
                            },
                          ),
                        ),
                        // Small Dark Mode Toggle on Home Screen
                        ValueListenableBuilder<ThemeMode>(
                          valueListenable: themeNotifier,
                          builder: (context, mode, _) {
                            final isDark = mode == ThemeMode.dark;
                            return IconButton(
                              onPressed: () {
                                themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
                              },
                              icon: Icon(
                                isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round,
                                color: AppColors.primary,
                                size: 28.r,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),

                    // Title & Add Task Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Today',
                          style: AppTextStyles.heading1,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final cubit = context.read<HomeCubit>();
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const AddTaskScreen(),
                              ),
                            );
                            // Refresh tasks if a task was added (result == true)
                            if (result == true) {
                              cubit.loadTasks();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            '+ Add Task',
                            style: AppTextStyles.buttonText.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // Date Slider
                    DateSlider(
                      selectedDate: state.selectedDate,
                      onDateSelected: (date) {
                        context.read<HomeCubit>().changeDate(date);
                      },
                    ),
                    SizedBox(height: 24.h),

                    // Task Filters
                    _buildFilters(context, state.selectedFilterIndex),
                    SizedBox(height: 24.h),

                    // Task List or Empty State
                    Expanded(
                      child: state.tasks.isEmpty
                          ? const Center(child: EmptyTaskState())
                          : ListView.builder(
                              itemCount: state.tasks.length,
                              itemBuilder: (context, index) {
                                final task = state.tasks[index];
                                return TaskTile(
                                  task: task,
                                  onComplete: () {
                                    context.read<HomeCubit>().markTaskAsCompleted(task);
                                  },
                                  onDelete: () {
                                    context.read<HomeCubit>().deleteTask(task.id);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context, int selectedIndex) {
    final List<String> filters = ['All', 'To-Do', 'Completed'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          filters.length,
          (index) => Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: ChoiceChip(
              label: Text(
                filters[index],
                style: TextStyle(
                  color: selectedIndex == index ? Colors.white : AppColors.textMain,
                  fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: selectedIndex == index,
              selectedColor: AppColors.primary,
              backgroundColor: Colors.transparent,
              side: BorderSide(
                color: selectedIndex == index ? AppColors.primary : Colors.grey[300]!,
              ),
              onSelected: (selected) {
                if (selected) {
                  context.read<HomeCubit>().changeFilter(index);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
