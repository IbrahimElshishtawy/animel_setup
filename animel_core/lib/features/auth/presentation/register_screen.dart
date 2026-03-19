import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../logic/auth_bloc.dart';
import '../widgets/auth_screen_frame.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      RegisterRequested({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go('/home');
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: AuthScreenFrame(
          title: 'Create your account',
          subtitle:
              'Set up your profile to buy, adopt, and connect with the Animal Connect community.',
          form: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  label: 'Full name',
                  controller: _nameController,
                  hint: 'Enter your full name',
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  validator: _validateName,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Email',
                  controller: _emailController,
                  hint: 'name@example.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Phone number',
                  controller: _phoneController,
                  hint: 'Enter your phone number',
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  prefixIcon: const Icon(Icons.phone_outlined),
                  validator: _validatePhone,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Password',
                  controller: _passwordController,
                  hint: 'Create a secure password',
                  obscure: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.newPassword],
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                  validator: _validatePassword,
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 24),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return AppButton(
                      title: 'Create account',
                      onPressed: _submit,
                      isLoading: state is AuthLoading,
                      borderRadius: 16,
                    );
                  },
                ),
              ],
            ),
          ),
          footer: TextButton(
            onPressed: () => context.pop(),
            child: const Text('Already have an account? Login'),
          ),
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Full name is required';
    if (text.length < 3) return 'Enter a valid full name';
    return null;
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(text)) return 'Enter a valid email';
    return null;
  }

  String? _validatePhone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Phone number is required';
    if (text.length < 8) return 'Enter a valid phone number';
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Password is required';
    if (text.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}
