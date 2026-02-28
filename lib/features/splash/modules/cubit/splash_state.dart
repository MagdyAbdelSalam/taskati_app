abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashCompleted extends SplashState {
  final bool isLoggedIn;
  SplashCompleted({required this.isLoggedIn});
}
