import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../auth/logic/auth_bloc.dart';
import '../../../core/models/user_model.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../widgets/account_header_icon.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _location = TextEditingController();
  final _bio = TextEditingController();
  final _profileImageUrl = TextEditingController();

  UserProfile? _user;
  bool _didSeed = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _location.dispose();
    _bio.dispose();
    _profileImageUrl.dispose();
    super.dispose();
  }

  void _seed(UserProfile user) {
    if (_didSeed) return;
    _didSeed = true;
    _user = user;
    _name.text = user.name;
    _email.text = user.email;
    _phone.text = user.phoneNumber;
    _location.text = user.location ?? '';
    _bio.text = user.bio ?? '';
    _profileImageUrl.text = user.profileImageUrl ?? '';
  }

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _save() {
    if (_name.text.trim().length < 2) {
      _showMessage('Please enter a valid name.');
      return;
    }

    context.read<AuthBloc>().add(
      ProfileUpdated({
        'name': _name.text.trim(),
        'phoneNumber': _phone.text.trim(),
        'location': _location.text.trim(),
        'bio': _bio.text.trim(),
        'profileImageUrl': _profileImageUrl.text.trim(),
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    const shell = Color(0xFFF7F2EC);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          _user = state.user;
          if (state.message != null) {
            _showMessage(state.message!);
            context.pop();
          }
        } else if (state is AuthFailure) {
          _showMessage(state.message);
        }
      },
      builder: (context, state) {
        if (state is Authenticated) {
          _seed(state.user);
        }

        final isSaving = state is AuthLoading;
        final user = _user;

        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: shell,
          appBar: AppBar(
            backgroundColor: shell,
            elevation: 0,
            title: const Text('Edit account'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AccountHeaderIcon(
                          imageUrl: _profileImageUrl.text.trim().isEmpty
                              ? user.profileImageUrl
                              : _profileImageUrl.text.trim(),
                          name: _name.text.trim().isEmpty
                              ? user.name
                              : _name.text.trim(),
                          subtitle: 'Profile preview',
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Profile details',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Email stays read-only here. The rest is connected to your profile update endpoint.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                height: 1.35,
                              ),
                        ),
                        const SizedBox(height: 18),
                        AppTextField(label: 'Full name', controller: _name),
                        const SizedBox(height: 12),
                        AppTextField(
                          label: 'Email',
                          controller: _email,
                          readOnly: true,
                          suffixIcon: const Icon(Icons.lock_outline_rounded),
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          label: 'Phone',
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 12),
                        AppTextField(label: 'Location', controller: _location),
                        const SizedBox(height: 12),
                        AppTextField(
                          label: 'Profile image URL',
                          controller: _profileImageUrl,
                          keyboardType: TextInputType.url,
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          label: 'Bio',
                          controller: _bio,
                          maxLines: 4,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: isSaving
                                    ? null
                                    : () => context.pop(),
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AppButton(
                                title: 'Save',
                                isLoading: isSaving,
                                onPressed: _save,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
