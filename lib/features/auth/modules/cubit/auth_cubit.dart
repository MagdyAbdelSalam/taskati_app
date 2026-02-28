import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../data/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedImagePath;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: source);
      if (image != null) {
        _selectedImagePath = image.path;
        emit(AuthImageSelected(image.path));
      }
    } catch (e) {
      emit(AuthError('Failed to pick image: \$e'));
    }
  }

  Future<void> saveProfile(String name) async {
    if (name.trim().isEmpty) {
      emit(AuthError('Please enter your name'));
      return;
    }

    emit(AuthSaving());
    try {
      
      await _authRepository.saveUserProfile(name.trim(), _selectedImagePath ?? '');
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError('Failed to save profile: \$e'));
    }
  }
}
