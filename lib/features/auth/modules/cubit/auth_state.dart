abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthImageSelected extends AuthState {
  final String imagePath;
  AuthImageSelected(this.imagePath);
}

class AuthSaving extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
