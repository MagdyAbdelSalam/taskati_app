import 'package:hive/hive.dart';
import 'task_model.dart';

class TaskRepository {
  static const String _taskBoxName = 'tasksBox';

  Future<void> initTaskBox() async {
    // Check if adapter is already registered to avoid errors in hot restarts
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskModelAdapter());
    }
    await Hive.openBox<TaskModel>(_taskBoxName);
  }

  Box<TaskModel> get _taskBox => Hive.box<TaskModel>(_taskBoxName);

  Future<void> addTask(TaskModel task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> updateTask(TaskModel task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
  }

  List<TaskModel> getTasksForDate(String date) {
    return _taskBox.values.where((task) => task.date == date).toList();
  }

  List<TaskModel> getAllTasks() {
    return _taskBox.values.toList();
  }
}
