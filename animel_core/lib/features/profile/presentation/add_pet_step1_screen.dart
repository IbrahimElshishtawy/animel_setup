import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';

class AddPetStep1Screen extends StatefulWidget {
  const AddPetStep1Screen({super.key});

  @override
  State<AddPetStep1Screen> createState() => _AddPetStep1ScreenState();
}

class _AddPetStep1ScreenState extends State<AddPetStep1Screen> {
  final _name = TextEditingController();
  final _dob = TextEditingController();
  final _type = TextEditingController();
  final _breed = TextEditingController();
  final _color = TextEditingController();
  final _behavior = TextEditingController();
  final _about = TextEditingController();
  final _favorites = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _name.dispose();
    _dob.dispose();
    _type.dispose();
    _breed.dispose();
    _color.dispose();
    _behavior.dispose();
    _about.dispose();
    _favorites.dispose();
    super.dispose();
  }

  void _next() {
    context.go("/profile/pets/add-step2");
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
      appBar: AppBar(title: const Text("Add pet - Step 1")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppTextField(label: "Name", controller: _name),
            const SizedBox(height: 12),
            AppTextField(label: "Date of birth", controller: _dob),
            const SizedBox(height: 12),
            AppTextField(
              label: "Type",
              hint: "Cat, Dog ...",
              controller: _type,
            ),
            const SizedBox(height: 12),
            AppTextField(label: "Breed", controller: _breed),
            const SizedBox(height: 12),
            AppTextField(label: "Color", controller: _color),
            const SizedBox(height: 24),
            AppButton(title: "Next", onPressed: _next),
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
