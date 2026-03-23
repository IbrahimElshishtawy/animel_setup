import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../auth/logic/auth_bloc.dart';
import '../widgets/account_buttons_row.dart';
import '../widgets/account_header_icon.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const shell = Color(0xFFF7F2EC);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! Authenticated) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = state.user;
        final nameParts = user.name.trim().split(RegExp(r'\s+'));
        final firstName = nameParts.isEmpty ? '' : nameParts.first;
        final lastName = nameParts.length > 1
            ? nameParts.sublist(1).join(' ')
            : '';

        return Scaffold(
          backgroundColor: shell,
          appBar: AppBar(
            backgroundColor: shell,
            elevation: 0,
            centerTitle: false,
            title: const Text('My account'),
          ),
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Container(
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
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        AccountHeaderIcon(
                          imageUrl: user.profileImageUrl,
                          name: user.name,
                          subtitle: user.email,
                        ),
                        const SizedBox(height: 20),
                        _SectionTitle(
                          title: 'Account details',
                          subtitle:
                              'A cleaner summary for your personal profile data.',
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _ReadOnlyField(
                                label: 'First name',
                                value: firstName,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _ReadOnlyField(
                                label: 'Last name',
                                value: lastName,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _ReadOnlyField(label: 'Email', value: user.email),
                        const SizedBox(height: 12),
                        _ReadOnlyField(label: 'Phone', value: user.phoneNumber),
                        const SizedBox(height: 12),
                        _ReadOnlyField(
                          label: 'Location',
                          value: user.location ?? '',
                        ),
                        const SizedBox(height: 12),
                        _ReadOnlyField(
                          label: 'Bio',
                          value: user.bio ?? '',
                          maxLines: 3,
                        ),
                        const SizedBox(height: 26),
                        AccountButtonsRow(
                          onClose: () => context.pop(),
                          onEdit: () => context.push('/profile/account/edit'),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({
    required this.label,
    required this.value,
    this.maxLines = 1,
  });

  final String label;
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F6F2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8E0D7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value.trim().isEmpty ? 'Not added yet' : value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
