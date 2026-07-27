import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/bootstrap/app_bootstrap.dart';
import 'core/providers/core_providers.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/otp_verification_screen.dart';
import 'features/auth/presentation/splash_screen.dart';
import 'features/chat/presentation/chat_screen.dart';
import 'features/home/presentation/home_shell.dart';

Future<void> main() async {
  await AppBootstrap.initialize();
  final preferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
      ],
      child: const MessengerApp(),
    ),
  );
}

class MessengerApp extends StatelessWidget {
  const MessengerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeafChat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        OtpVerificationScreen.routeName: (_) => const OtpVerificationScreen(),
        HomeShell.routeName: (_) => const HomeShell(),
        ChatScreen.routeName: (_) => const ChatScreen(),
      },
    );
  }
}
