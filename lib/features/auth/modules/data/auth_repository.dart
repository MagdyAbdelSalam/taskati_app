import 'package:hive/hive.dart';

class AuthRepository {
  static const String _userBoxName = 'userBox';
  static const String _nameKey = 'username';
  static const String _imageKey = 'profile_image_path';

  Future<void> initUserBox() async {
    await Hive.openBox(_userBoxName);
  }

  Future<void> saveUserProfile(String name, String imagePath) async {
    final box = Hive.box(_userBoxName);
    await box.put(_nameKey, name);
    await box.put(_imageKey, imagePath);
  }

  String? getUserName() {
    final box = Hive.box(_userBoxName);
    return box.get(_nameKey);
  }

  String? getUserImagePath() {
    final box = Hive.box(_userBoxName);
    return box.get(_imageKey);
  }

  bool isUserLoggedIn() {
    final box = Hive.box(_userBoxName);
    return box.containsKey(_nameKey);
  }
}
