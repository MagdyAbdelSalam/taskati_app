import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/modules/data/auth_repository.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  void startSplash() async {
    emit(SplashLoading());
    await Future.delayed(const Duration(seconds: 3));
    // Check if user already saved their profile in Hive
    final authRepo = AuthRepository();
    final isLoggedIn = authRepo.isUserLoggedIn();
    emit(SplashCompleted(isLoggedIn: isLoggedIn));
  }
}
