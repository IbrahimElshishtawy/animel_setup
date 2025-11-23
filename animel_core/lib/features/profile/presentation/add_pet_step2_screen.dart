import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';

class AddPetStep2Screen extends StatefulWidget {
  const AddPetStep2Screen({super.key});

  @override
  State<AddPetStep2Screen> createState() => _AddPetStep2ScreenState();
}

class _AddPetStep2ScreenState extends State<AddPetStep2Screen> {
  final _behavior = TextEditingController();
  final _about = TextEditingController();
  final _favorites = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _behavior.dispose();
    _about.dispose();
    _favorites.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    if (!mounted) return;
    context.go("/profile/pets");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add pet - Step 2")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppTextField(label: "Behavior", controller: _behavior),
            const SizedBox(height: 12),
            AppTextField(
              label: "About / special marks",
              controller: _about,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: "Favorites",
              controller: _favorites,
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            AppButton(title: "Save", isLoading: _isLoading, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
