import '../data/task_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<TaskModel> tasks;
  final DateTime selectedDate;
  final int selectedFilterIndex; // 0 = All, 1 = To-Do, 2 = Completed

  HomeLoaded({
    required this.tasks,
    required this.selectedDate,
    required this.selectedFilterIndex,
  });
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
