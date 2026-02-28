import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_colors.dart';
import '../modules/data/task_model.dart';

/// A swipeable task card matching the mockup design.
/// Swipe RIGHT → Mark as Completed (green background revealed)
/// Swipe LEFT  → Delete from Hive (red background revealed)
class TaskTile extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onComplete;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final Color taskColor = AppColors.taskColors[
        task.colorIndex.clamp(0, AppColors.taskColors.length - 1)];

    return Opacity(
      opacity: task.isCompleted ? 0.55 : 1.0,
      child: Dismissible(
        key: ValueKey(task.id),
        // --- Swipe Right → Complete (disabled if already completed) ---
        direction: task.isCompleted
            ? DismissDirection.endToStart // Only allow delete if already done
            : DismissDirection.horizontal,
        background: _buildSwipeBackground(
          alignment: Alignment.centerLeft,
          color: const Color(0xFF4CAF50),
          icon: Icons.check_circle_outline,
          label: 'Complete',
        ),
        // --- Swipe Left → Delete ---
        secondaryBackground: _buildSwipeBackground(
          alignment: Alignment.centerRight,
          color: Colors.red.shade600,
          icon: Icons.delete_outline,
          label: 'Delete',
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            onComplete();
            return false;
          } else {
            onDelete();
            return false;
          }
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 14.h),
          decoration: BoxDecoration(
            color: taskColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: taskColor.withAlpha(task.isCompleted ? 40 : 100),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // --- Left: Task Content ---
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title — strikethrough when completed
                        Text(
                          task.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationColor: Colors.white,
                            decorationThickness: 2,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Time Row
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              color: Colors.white70,
                              size: 14.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              '${task.startTime} - ${task.endTime}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                        if (task.note.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          Text(
                            task.note,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withAlpha(200),
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                // --- Right: Vertical Divider + Status Label ---
                Container(
                  width: 1.w,
                  color: Colors.white.withAlpha(80),
                  margin: EdgeInsets.symmetric(vertical: 12.h),
                ),
                SizedBox(width: 12.w),
                RotatedBox(
                  quarterTurns: 1,
                  child: Text(
                    task.isCompleted ? 'DONE' : 'TODO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({
    required AlignmentGeometry alignment,
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Container(
      alignment: alignment,
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.centerLeft) ...[
            Icon(icon, color: Colors.white, size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ] else ...[
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(icon, color: Colors.white, size: 24.sp),
          ]
        ],
      ),
    );
  }
}
