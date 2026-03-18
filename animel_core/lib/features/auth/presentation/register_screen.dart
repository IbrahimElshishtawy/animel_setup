import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../logic/auth_bloc.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go('/home');
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              AppTextField(
                label: 'Full Name',
                controller: _nameController,
                hint: 'Enter your full name',
                prefixIcon: const Icon(Icons.person),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Email',
                controller: _emailController,
                hint: 'Enter your email',
                prefixIcon: const Icon(Icons.email),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Phone Number',
                controller: _phoneController,
                hint: 'Enter your phone number',
                prefixIcon: const Icon(Icons.phone),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Password',
                controller: _passwordController,
                hint: 'Enter your password',
                prefixIcon: const Icon(Icons.lock),
                obscure: true,
              ),
              const SizedBox(height: 32),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return AppButton(
                    title: 'Register',
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        RegisterRequested({
                          'name': _nameController.text,
                          'email': _emailController.text,
                          'password': _passwordController.text,
                          'phoneNumber': _phoneController.text,
                        }),
                      );
                    },
                    isLoading: state is AuthLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
