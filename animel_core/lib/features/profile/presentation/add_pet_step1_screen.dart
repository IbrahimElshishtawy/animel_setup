import 'package:animel_core/features/profile/widgets/add_photos_box.dart';
import 'package:animel_core/features/profile/widgets/choice_chip_button.dart';
import 'package:animel_core/features/profile/widgets/dropdown_field.dart';
import 'package:animel_core/features/profile/widgets/header_icon.dart';
import 'package:animel_core/features/profile/widgets/pet_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../home/logic/animal_bloc.dart';

class AddPetStep2Screen extends StatefulWidget {
  const AddPetStep2Screen({super.key});

  @override
  State<AddPetStep2Screen> createState() => _AddPetStep2ScreenState();
}

class _AddPetStep2ScreenState extends State<AddPetStep2Screen> {
  static const _fallbackLatitude = 30.0444;
  static const _fallbackLongitude = 31.2357;

  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _weightController = TextEditingController();
  final _aboutController = TextEditingController();
  final _favoritesController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String _selectedPetType = 'Cat';
  String _selectedGender = 'Male';
  String _selectedSize = 'Small';
  String _selectedBreed = 'Mixed';
  String _selectedColor = 'Brown';
  String _selectedBehavior = 'Calm';
  String _selectedHealthStatus = 'Healthy';
  bool _isForAdoption = false;

  @override
  void initState() {
    super.initState();
    context.read<AnimalBloc>().add(ClearAnimalMessage());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _weightController.dispose();
    _aboutController.dispose();
    _favoritesController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String? _validateForm() {
    if (_nameController.text.trim().length < 2) {
      return 'Please enter the pet name';
    }
    if (_dobController.text.trim().isEmpty) {
      return 'Please choose the date of birth';
    }
    if (_locationController.text.trim().length < 2) {
      return 'Please enter the pet location';
    }
    if (_aboutController.text.trim().length < 10) {
      return 'Please add a short description with at least 10 characters';
    }
    if (!_isForAdoption) {
      final price = double.tryParse(_priceController.text.trim());
      if (price == null || price < 0) {
        return 'Please enter a valid price';
      }
    }
    return null;
  }

  String _buildAgeLabel() {
    final raw = _dobController.text.trim();
    final parts = raw.split('/');
    if (parts.length != 3) return raw;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return raw;

    final dob = DateTime(year, month, day);
    final now = DateTime.now();
    var years = now.year - dob.year;
    var months = now.month - dob.month;
    if (now.day < dob.day) {
      months -= 1;
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }

    if (years > 0) {
      return years == 1 ? '1 year' : '$years years';
    }
    if (months > 0) {
      return months == 1 ? '1 month' : '$months months';
    }
    return 'Less than 1 month';
  }

  String _buildDescription() {
    final segments = <String>[
      _aboutController.text.trim(),
      'Color: $_selectedColor',
      'Behavior: $_selectedBehavior',
      if (_weightController.text.trim().isNotEmpty)
        'Weight: ${_weightController.text.trim()} kg',
      if (_favoritesController.text.trim().isNotEmpty)
        'Favorites: ${_favoritesController.text.trim()}',
    ];

    return segments.where((segment) => segment.isNotEmpty).join(' | ');
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final validationMessage = _validateForm();
    if (validationMessage != null) {
      _showMessage(validationMessage);
      return;
    }

    final payload = <String, dynamic>{
      'name': _nameController.text.trim(),
      'type': _selectedPetType,
      'breed': _selectedBreed,
      'age': _buildAgeLabel(),
      'gender': _selectedGender,
      'size': _selectedSize,
      'price': _isForAdoption
          ? 0
          : double.parse(_priceController.text.trim()),
      'location': _locationController.text.trim(),
      'latitude': _fallbackLatitude,
      'longitude': _fallbackLongitude,
      'description': _buildDescription(),
      'imageUrls': _imageUrlController.text.trim().isEmpty
          ? <String>[]
          : <String>[_imageUrlController.text.trim()],
      'isForAdoption': _isForAdoption,
      'healthStatus': _selectedHealthStatus,
    };

    context.read<AnimalBloc>().add(CreateAnimalRequested(payload));
  }

  @override
  Widget build(BuildContext context) {
    const plum = Color(0xFF4B1A45);
    const shell = Color(0xFFF6ECF3);

    return BlocConsumer<AnimalBloc, AnimalState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          _showMessage(state.errorMessage!);
          context.read<AnimalBloc>().add(ClearAnimalMessage());
        }

        if (state.successMessage != null) {
          _showMessage(state.successMessage!);
          context.read<AnimalBloc>().add(ClearAnimalMessage());
          context.go('/profile/pets');
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: shell,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: plum,
            title: const Text(
              'Set a pet profile',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Container(
                  color: Colors.white,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    children: [
                      const HeaderIcon(),
                      const SizedBox(height: 16),
                      Text(
                        'Build a strong profile for your pet before listing, adoption, or future updates.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Listing type',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ChoiceChipButton(
                            label: 'For sale',
                            isSelected: !_isForAdoption,
                            onTap: () => setState(() => _isForAdoption = false),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChipButton(
                            label: 'For adoption',
                            isSelected: _isForAdoption,
                            onTap: () => setState(() => _isForAdoption = true),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      PetTextField(label: 'Name', controller: _nameController),
                      const SizedBox(height: 12),
                      PetTextField(
                        label: 'Date of birth',
                        controller: _dobController,
                        suffixIcon: Icons.calendar_today_outlined,
                        readOnly: true,
                        onTap: () async {
                          final now = DateTime.now();
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(now.year - 1),
                            firstDate: DateTime(now.year - 25),
                            lastDate: now,
                          );
                          if (picked != null) {
                            _dobController.text =
                                '${picked.day}/${picked.month}/${picked.year}';
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      PetTextField(
                        label: 'Location',
                        controller: _locationController,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Pet',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ChoiceChipButton(
                            label: 'Cat',
                            isSelected: _selectedPetType == 'Cat',
                            onTap: () => setState(() => _selectedPetType = 'Cat'),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChipButton(
                            label: 'Dog',
                            isSelected: _selectedPetType == 'Dog',
                            onTap: () => setState(() => _selectedPetType = 'Dog'),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChipButton(
                            label: 'Bird',
                            isSelected: _selectedPetType == 'Bird',
                            onTap: () => setState(() => _selectedPetType = 'Bird'),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChipButton(
                            label: 'Other',
                            isSelected: _selectedPetType == 'Other',
                            onTap: () => setState(() => _selectedPetType = 'Other'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownField(
                        label: 'Breed',
                        value: _selectedBreed,
                        items: const [
                          'Mixed',
                          'Persian',
                          'Siamese',
                          'Golden Retriever',
                          'German Shepherd',
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedBreed = val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownField(
                        label: 'Color',
                        value: _selectedColor,
                        items: const ['Brown', 'Black', 'White', 'Gray', 'Mixed'],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedColor = val);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Gender',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ChoiceChipButton(
                            label: 'Male',
                            isSelected: _selectedGender == 'Male',
                            onTap: () => setState(() => _selectedGender = 'Male'),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChipButton(
                            label: 'Female',
                            isSelected: _selectedGender == 'Female',
                            onTap: () =>
                                setState(() => _selectedGender = 'Female'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      PetTextField(
                        label: 'Weight (kg)',
                        controller: _weightController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Size',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ChoiceChipButton(
                            label: 'Small',
                            isSelected: _selectedSize == 'Small',
                            onTap: () => setState(() => _selectedSize = 'Small'),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChipButton(
                            label: 'Medium',
                            isSelected: _selectedSize == 'Medium',
                            onTap: () =>
                                setState(() => _selectedSize = 'Medium'),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChipButton(
                            label: 'Large',
                            isSelected: _selectedSize == 'Large',
                            onTap: () => setState(() => _selectedSize = 'Large'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownField(
                        label: 'Behavior',
                        value: _selectedBehavior,
                        items: const ['Calm', 'Playful', 'Aggressive', 'Shy'],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedBehavior = val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownField(
                        label: 'Health status',
                        value: _selectedHealthStatus,
                        items: const [
                          'Healthy',
                          'Needs care',
                          'Recovering',
                          'Special needs',
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedHealthStatus = val);
                          }
                        },
                      ),
                      if (!_isForAdoption) ...[
                        const SizedBox(height: 12),
                        PetTextField(
                          label: 'Price',
                          controller: _priceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      PetTextField(
                        label: 'About / Special marks',
                        controller: _aboutController,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 12),
                      PetTextField(
                        label: 'Favorites',
                        controller: _favoritesController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 12),
                      PetTextField(
                        label: 'Cover image URL (optional)',
                        controller: _imageUrlController,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Add more photos',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AddPhotosBox(
                        onTap: () {
                          _showMessage(
                            'Image upload is not connected yet. You can paste one image URL for now.',
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: plum,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: state.isSubmitting ? null : _submit,
                          child: state.isSubmitting
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
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
