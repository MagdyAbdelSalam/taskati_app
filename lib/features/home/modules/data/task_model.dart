import 'package:hive/hive.dart';

// Hive Type IDs must be unique across the app. We'll use 1 for TaskModel.
// 0 was implicitly left for raw strings/types in the userBox. 
// However, best practice is to assign explicit TypeIDs.

class TaskModel {
  final String id;
  final String title;
  final String note;
  final String date;
  final String startTime;
  final String endTime;
  final int colorIndex; // To save color cleanly
  final bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.note,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.colorIndex,
    this.isCompleted = false,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? note,
    String? date,
    String? startTime,
    String? endTime,
    int? colorIndex,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      colorIndex: colorIndex ?? this.colorIndex,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 1;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      id: fields[0] as String,
      title: fields[1] as String,
      note: fields[2] as String,
      date: fields[3] as String,
      startTime: fields[4] as String,
      endTime: fields[5] as String,
      colorIndex: fields[6] as int,
      isCompleted: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.note)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.startTime)
      ..writeByte(5)
      ..write(obj.endTime)
      ..writeByte(6)
      ..write(obj.colorIndex)
      ..writeByte(7)
      ..write(obj.isCompleted);
  }
}
