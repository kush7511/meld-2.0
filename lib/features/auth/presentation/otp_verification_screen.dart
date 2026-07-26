import 'package:flutter/material.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_input_field.dart';
import '../../home/presentation/home_shell.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  static const routeName = '/otp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: AppCard(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Verify OTP',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Enter the 6-digit code sent to your phone.'),
                  const SizedBox(height: 20),
                  const AppInputField(
                    label: 'Verification code',
                    hint: '123456',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.password_rounded,
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    label: 'Verify and continue',
                    icon: Icons.check_rounded,
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      HomeShell.routeName,
                      (_) => false,
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
