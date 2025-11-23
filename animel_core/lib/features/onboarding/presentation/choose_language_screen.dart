import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({super.key});

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  String _lang = "en";

  void _continue() {
    context.go("/permissions-info");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.pets, size: 80, color: Color(0xFF4B1A45)),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _lang,
                items: const [
                  DropdownMenuItem(value: "en", child: Text("English")),
                  DropdownMenuItem(value: "ar", child: Text("العربية")),
                ],
                onChanged: (v) => setState(() => _lang = v ?? "en"),
                decoration: const InputDecoration(
                  labelText: "Choose a language",
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B1A45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _continue,
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
