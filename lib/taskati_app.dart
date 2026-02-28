import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/app_theme.dart';
import 'features/splash/screen/splash_screen.dart';

/// Global theme notifier — allows any widget in the tree to toggle dark mode
/// by calling `themeNotifier.value = ThemeMode.dark / ThemeMode.light`
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

class TaskatiApp extends StatelessWidget {
  const TaskatiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (_, mode, __) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Taskati',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: mode, // Driven by the global notifier
              home: child,
            );
          },
        );
      },
      child: const SplashScreen(),
    );
  }
}
