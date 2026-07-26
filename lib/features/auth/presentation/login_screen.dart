import 'package:flutter/material.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_input_field.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.mark_unread_chat_alt_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 46,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Welcome back',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in with your phone number to continue.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black54),
                  ),
                  const SizedBox(height: 28),
                  AppCard(
                    child: Column(
                      children: [
                        const AppInputField(
                          label: 'Phone number',
                          hint: '+1 555 012 3344',
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone_rounded,
                        ),
                        const SizedBox(height: 16),
                        AppButton(
                          label: 'Send verification code',
                          icon: Icons.arrow_forward_rounded,
                          onPressed: () => Navigator.pushNamed(
                            context,
                            OtpVerificationScreen.routeName,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
