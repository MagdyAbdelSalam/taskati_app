import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/app_text_styles.dart';
import '../modules/cubit/splash_cubit.dart';
import '../modules/cubit/splash_state.dart';
import '../widgets/taskati_logo.dart';
import '../../auth/screen/auth_screen.dart';
import '../../home/screen/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..startSplash(),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashCompleted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => state.isLoggedIn
                  ? const HomeScreen() // Already set up → go straight to Home
                  : const AuthScreen(), // First launch → go to Auth
            ),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const TaskatiLogo(),
                      SizedBox(height: 40.h),
                      Text(
                        'Taskati',
                        style: AppTextStyles.heading1.copyWith(
                          fontSize: 32.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "It's Time to Get Organized",
                        style: AppTextStyles.subtitle.copyWith(
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
