abstract class AddTaskState {}

class AddTaskInitial extends AddTaskState {}

class AddTaskLoading extends AddTaskState {}

class AddTaskFieldsUpdated extends AddTaskState {
  final String date;
  final String startTime;
  final String endTime;
  final int selectedColorIndex;

  AddTaskFieldsUpdated({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.selectedColorIndex,
  });
}

class AddTaskSuccess extends AddTaskState {}

class AddTaskError extends AddTaskState {
  final String message;
  AddTaskError(this.message);
}
