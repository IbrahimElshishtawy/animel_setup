import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';

class ReportStep1Screen extends StatefulWidget {
  const ReportStep1Screen({super.key});

  @override
  State<ReportStep1Screen> createState() => _ReportStep1ScreenState();
}

class _ReportStep1ScreenState extends State<ReportStep1Screen> {
  final _name = TextEditingController();
  final _color = TextEditingController();
  final _category = TextEditingController();
  final _age = TextEditingController();
  final _description = TextEditingController();
  bool _isLost = true;

  @override
  void dispose() {
    _name.dispose();
    _color.dispose();
    _category.dispose();
    _age.dispose();
    _description.dispose();
    super.dispose();
  }

  void _next() {
    context.go("/report-step2");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report pet - Step 1")),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  ChoiceChip(
                    label: const Text("Lost"),
                    selected: _isLost,
                    onSelected: (_) => setState(() => _isLost = true),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text("Found"),
                    selected: !_isLost,
                    onSelected: (_) => setState(() => _isLost = false),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppTextField(label: "Pet name", controller: _name),
              const SizedBox(height: 12),
              AppTextField(label: "Color", controller: _color),
              const SizedBox(height: 12),
              AppTextField(
                label: "Category",
                hint: "Cat, Dog, Bird ...",
                controller: _category,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: "Age",
                controller: _age,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: "Description",
                controller: _description,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              AppButton(title: "Next", onPressed: _next),
            ],
          ),
        ),
      ),
    );
  }
}
