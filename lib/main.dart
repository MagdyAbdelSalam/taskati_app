import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/auth/modules/data/auth_repository.dart';
import 'features/home/modules/data/task_repository.dart';
import 'taskati_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // Initialize repositories and boxes
  final authRepo = AuthRepository();
  await authRepo.initUserBox();
  
  final taskRepo = TaskRepository();
  await taskRepo.initTaskBox();
  
  runApp(const TaskatiApp());
}
