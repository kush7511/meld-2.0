import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_input_field.dart';
import '../../home/presentation/home_shell.dart';
import '../application/auth_controller.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _rememberMe = true;
  bool _navigateOnSuccess = false;
  int _modeIndex = 0;

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          if (!mounted || !_navigateOnSuccess) return;
          _navigateOnSuccess = false;
          final route = _modeIndex == 1
              ? OtpVerificationScreen.routeName
              : HomeShell.routeName;
          Navigator.pushNamedAndRemoveUntil(context, route, (_) => false);
        },
        error: (error, stackTrace) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
      );
    });

    final authState = ref.watch(authControllerProvider);

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
                    'Sign in securely to continue.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.black54),
                  ),
                  const SizedBox(height: 28),
                  AppCard(
                    child: Column(
                      children: [
                        SegmentedButton<int>(
                          segments: const [
                            ButtonSegment(
                              value: 0,
                              icon: Icon(Icons.mail_rounded),
                              label: Text('Email'),
                            ),
                            ButtonSegment(
                              value: 1,
                              icon: Icon(Icons.phone_rounded),
                              label: Text('Phone'),
                            ),
                          ],
                          selected: {_modeIndex},
                          onSelectionChanged: (selection) {
                            setState(() => _modeIndex = selection.first);
                          },
                        ),
                        const SizedBox(height: 18),
                        if (_modeIndex == 0) ...[
                          AppInputField(
                            controller: _emailController,
                            label: 'Email',
                            hint: 'you@example.com',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.mail_rounded,
                          ),
                          const SizedBox(height: 16),
                          AppInputField(
                            controller: _passwordController,
                            label: 'Password',
                            obscureText: true,
                            prefixIcon: Icons.lock_rounded,
                          ),
                        ] else
                          AppInputField(
                            controller: _phoneController,
                            label: 'Phone number',
                            hint: '+1 555 012 3344',
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icons.phone_rounded,
                          ),
                        const SizedBox(height: 8),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() => _rememberMe = value ?? true);
                          },
                          title: const Text('Remember me'),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        const SizedBox(height: 8),
                        AppButton(
                          label: _modeIndex == 0
                              ? 'Sign in'
                              : 'Send verification code',
                          icon: Icons.arrow_forward_rounded,
                          onPressed: authState.isLoading ? null : _submit,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: authState.isLoading
                                    ? null
                                    : () {
                                        _navigateOnSuccess = true;
                                        ref
                                            .read(
                                              authControllerProvider.notifier,
                                            )
                                            .signInWithGoogle(
                                              rememberMe: _rememberMe,
                                            );
                                      },
                                icon: const Icon(Icons.g_mobiledata_rounded),
                                label: const Text('Google'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: authState.isLoading
                                    ? null
                                    : () => _showPlaceholder(
                                          'Apple Sign-In is ready for platform setup.',
                                        ),
                                icon: const Icon(Icons.apple_rounded),
                                label: const Text('Apple'),
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed:
                              authState.isLoading ? null : _sendPasswordReset,
                          child: const Text('Forgot password?'),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final controller = ref.read(authControllerProvider.notifier);
    _navigateOnSuccess = true;
    if (_modeIndex == 0) {
      await controller.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );
      return;
    }

    await controller.startPhoneLogin(_phoneController.text.trim());
  }

  Future<void> _sendPasswordReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showPlaceholder('Enter your email before requesting a reset link.');
      return;
    }
    _navigateOnSuccess = false;
    await ref.read(authControllerProvider.notifier).sendPasswordReset(email);
  }

  void _showPlaceholder(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
