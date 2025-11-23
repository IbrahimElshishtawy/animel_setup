import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';

class ReportStep2Screen extends StatefulWidget {
  const ReportStep2Screen({super.key});

  @override
  State<ReportStep2Screen> createState() => _ReportStep2ScreenState();
}

class _ReportStep2ScreenState extends State<ReportStep2Screen> {
  final _reward = TextEditingController();
  final _lastSeenDate = TextEditingController();
  final _lastSeenTime = TextEditingController();
  final _address = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _reward.dispose();
    _lastSeenDate.dispose();
    _lastSeenTime.dispose();
    _address.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    if (!mounted) return;
    context.go("/home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report pet - Step 2")),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AppTextField(
                label: "Reward (optional)",
                controller: _reward,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: "Last seen date",
                hint: "2025-11-23",
                controller: _lastSeenDate,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: "Last seen time",
                hint: "14:30",
                controller: _lastSeenTime,
              ),
              const SizedBox(height: 12),
              AppTextField(label: "Address", controller: _address, maxLines: 2),
              const SizedBox(height: 12),
              AppTextField(
                label: "Contact email",
                controller: _email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: "Contact phone",
                controller: _phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              AppButton(
                title: "Submit report",
                isLoading: _isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
