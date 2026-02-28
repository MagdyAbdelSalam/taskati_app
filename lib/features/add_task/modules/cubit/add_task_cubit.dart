import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../home/modules/data/task_model.dart';
import '../../../home/modules/data/task_repository.dart';
import 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  final TaskRepository _taskRepository;

  // Internal state values
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  int _selectedColorIndex = 0;

  AddTaskCubit(this._taskRepository) : super(AddTaskInitial()) {
    // Emit initial field state with today's date
    _emitFieldsUpdated();
  }

  String get formattedDate => DateFormat('yyyy-MM-dd').format(_selectedDate);
  String get formattedStartTime => _startTime != null ? _formatTime(_startTime!) : '';
  String get formattedEndTime => _endTime != null ? _formatTime(_endTime!) : '';
  int get selectedColorIndex => _selectedColorIndex;

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  void _emitFieldsUpdated() {
    emit(AddTaskFieldsUpdated(
      date: formattedDate,
      startTime: formattedStartTime,
      endTime: formattedEndTime,
      selectedColorIndex: _selectedColorIndex,
    ));
  }

  void selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(DateTime.now()) ? DateTime.now() : _selectedDate,
      firstDate: DateTime.now(), // Only today or future dates
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _selectedDate = picked;
      _emitFieldsUpdated();
    }
  }

  void selectStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      _startTime = picked;
      // Reset end time if it's now before start time
      if (_endTime != null && !_isEndAfterStart(_startTime!, _endTime!)) {
        _endTime = null;
      }
      _emitFieldsUpdated();
    }
  }

  void selectEndTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? (_startTime ?? TimeOfDay.now()),
    );
    if (picked != null) {
      // Validate: End time must be after start time
      if (_startTime != null && !_isEndAfterStart(_startTime!, picked)) {
        emit(AddTaskError('End time must be after start time!'));
        // After a short delay, go back to fields updated to clear error
        await Future.delayed(const Duration(milliseconds: 1500));
        _emitFieldsUpdated();
        return;
      }
      _endTime = picked;
      _emitFieldsUpdated();
    }
  }

  bool _isEndAfterStart(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return endMinutes > startMinutes;
  }

  void selectColor(int index) {
    _selectedColorIndex = index;
    _emitFieldsUpdated();
  }

  Future<void> saveTask({
    required String title,
    required String note,
  }) async {
    if (title.trim().isEmpty) {
      emit(AddTaskError('Title is required'));
      return;
    }
    if (_startTime == null) {
      emit(AddTaskError('Start time is required'));
      return;
    }
    if (_endTime == null) {
      emit(AddTaskError('End time is required'));
      return;
    }

    emit(AddTaskLoading());
    try {
      final task = TaskModel(
        id: DateTime.now().toIso8601String(),
        title: title.trim(),
        note: note.trim(),
        date: formattedDate,
        startTime: formattedStartTime,
        endTime: formattedEndTime,
        colorIndex: _selectedColorIndex,
        isCompleted: false,
      );
      await _taskRepository.addTask(task);
      emit(AddTaskSuccess());
    } catch (e) {
      emit(AddTaskError('Failed to save task: $e'));
    }
  }
}
