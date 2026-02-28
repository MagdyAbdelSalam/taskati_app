import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../data/task_model.dart';
import '../data/task_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final TaskRepository _taskRepository;
  
  DateTime _selectedDate = DateTime.now();
  int _selectedFilterIndex = 0; // 0: All, 1: To-Do, 2: Completed

  HomeCubit(this._taskRepository) : super(HomeInitial());

  void loadTasks() {
    emit(HomeLoading());
    try {
      final String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final List<TaskModel> allTasksForDate = _taskRepository.getTasksForDate(formattedDate);
      
      List<TaskModel> filteredTasks;
      if (_selectedFilterIndex == 2) {
        // Completed only
        filteredTasks = allTasksForDate.where((t) => t.isCompleted).toList();
      } else if (_selectedFilterIndex == 1) {
        // To-Do only (not completed)
        filteredTasks = allTasksForDate.where((t) => !t.isCompleted).toList();
      } else {
        // All = non-completed tasks only (completed tasks go to "Completed" tab)
        filteredTasks = allTasksForDate.where((t) => !t.isCompleted).toList();
      }

      emit(HomeLoaded(
        tasks: filteredTasks,
        selectedDate: _selectedDate,
        selectedFilterIndex: _selectedFilterIndex,
      ));
    } catch (e) {
      emit(HomeError('Failed to load tasks: \$e'));
    }
  }

  void changeDate(DateTime date) {
    _selectedDate = date;
    loadTasks();
  }

  void changeFilter(int index) {
    _selectedFilterIndex = index;
    loadTasks();
  }

  Future<void> markTaskAsCompleted(TaskModel task) async {
    final updatedTask = task.copyWith(isCompleted: true);
    await _taskRepository.updateTask(updatedTask);
    loadTasks(); // Refresh UI
  }

  Future<void> deleteTask(String taskId) async {
    await _taskRepository.deleteTask(taskId);
    loadTasks(); // Refresh UI
  }
}
