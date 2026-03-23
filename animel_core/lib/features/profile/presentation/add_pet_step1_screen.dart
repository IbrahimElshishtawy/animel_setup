import 'dart:convert';

import 'package:animel_core/core/widgets/app_media.dart';
import 'package:animel_core/features/profile/widgets/add_photos_box.dart';
import 'package:animel_core/features/profile/widgets/dropdown_field.dart';
import 'package:animel_core/features/profile/widgets/header_icon.dart';
import 'package:animel_core/features/profile/widgets/pet_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/localization/app_copy.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
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
  final ImagePicker _imagePicker = ImagePicker();
  final List<String> _selectedImageUrls = [];

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
    super.dispose();
  }

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String? _validateForm() {
    final copy = context.copy;
    if (_nameController.text.trim().length < 2) {
      return copy.petNameValidation;
    }
    if (_dobController.text.trim().isEmpty) {
      return copy.petDobValidation;
    }
    if (_locationController.text.trim().length < 2) {
      return copy.petLocationValidation;
    }
    if (_aboutController.text.trim().length < 10) {
      return copy.petDescriptionValidation;
    }
    if (_selectedImageUrls.isEmpty) {
      return copy.petPhotoValidation;
    }
    if (!_isForAdoption) {
      final price = double.tryParse(_priceController.text.trim());
      if (price == null || price < 0) {
        return copy.validPriceValidation;
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
      return years == 1
          ? context.copy.yearLabel(years)
          : context.copy.yearsLabel(years);
    }
    if (months > 0) {
      return months == 1
          ? context.copy.monthLabel(months)
          : context.copy.monthsLabel(months);
    }
    return context.copy.lessThanOneMonth;
  }

  String _buildDescription() {
    final copy = context.copy;
    final segments = <String>[
      _aboutController.text.trim(),
      '${copy.color}: ${copy.petFormOption(_selectedColor)}',
      '${copy.behavior}: ${copy.petFormOption(_selectedBehavior)}',
      if (_weightController.text.trim().isNotEmpty)
        '${copy.weightKg}: ${_weightController.text.trim()}',
      if (_favoritesController.text.trim().isNotEmpty)
        '${copy.favorites}: ${_favoritesController.text.trim()}',
    ];

    return segments.where((segment) => segment.isNotEmpty).join(' | ');
  }

  Future<void> _pickImages() async {
    final remainingSlots = 4 - _selectedImageUrls.length;
    if (remainingSlots <= 0) {
      _showMessage(context.copy.photoLimitMessage(4));
      return;
    }

    final pickedFiles = await _imagePicker.pickMultiImage(
      imageQuality: 60,
      maxWidth: 1280,
      maxHeight: 1280,
    );

    if (pickedFiles.isEmpty) return;

    final limitedFiles = pickedFiles.take(remainingSlots).toList();
    final newImages = <String>[];

    for (final file in limitedFiles) {
      final bytes = await file.readAsBytes();
      newImages.add(_buildDataUri(file, bytes));
    }

    if (!mounted) return;

    setState(() {
      _selectedImageUrls.addAll(newImages);
    });

    if (pickedFiles.length > remainingSlots) {
      _showMessage(context.copy.firstPhotosAdded(remainingSlots));
    }
  }

  String _buildDataUri(XFile file, List<int> bytes) {
    final extension = file.name.split('.').last.toLowerCase();
    final mimeType = switch (extension) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      _ => 'image/jpeg',
    };

    return 'data:$mimeType;base64,${base64Encode(bytes)}';
  }

  void _removeImageAt(int index) {
    setState(() {
      _selectedImageUrls.removeAt(index);
    });
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
      'price': _isForAdoption ? 0 : double.parse(_priceController.text.trim()),
      'location': _locationController.text.trim(),
      'latitude': _fallbackLatitude,
      'longitude': _fallbackLongitude,
      'description': _buildDescription(),
      'imageUrls': List<String>.from(_selectedImageUrls),
      'isForAdoption': _isForAdoption,
      'healthStatus': _selectedHealthStatus,
    };

    context.read<AnimalBloc>().add(CreateAnimalRequested(payload));
  }

  @override
  Widget build(BuildContext context) {
    final copy = context.copy;
    const plum = Color(0xFF7E452A);
    const shell = Color(0xFFF7F2EC);

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
          bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
          appBar: AppBar(
            backgroundColor: shell,
            elevation: 0,
            foregroundColor: plum,
            title: Text(
              copy.setPetProfile,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Container(
                  margin: const EdgeInsets.all(14),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    children: [
                      HeaderIcon(
                        imageUrl: _selectedImageUrls.isEmpty
                            ? null
                            : _selectedImageUrls.first,
                        title: copy.setPetProfile,
                        subtitle: copy.petProfileIntro,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        copy.listingType,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _InlineChoiceChip(
                            label: copy.forSale,
                            isSelected: !_isForAdoption,
                            onTap: () => setState(() => _isForAdoption = false),
                          ),
                          _InlineChoiceChip(
                            label: copy.forAdoptionOption,
                            isSelected: _isForAdoption,
                            onTap: () => setState(() => _isForAdoption = true),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      PetTextField(
                        label: copy.nameLabel,
                        controller: _nameController,
                      ),
                      const SizedBox(height: 12),
                      PetTextField(
                        label: copy.dateOfBirth,
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
                        label: copy.location,
                        controller: _locationController,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        copy.pet,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _InlineChoiceChip(
                            label: copy.petFormOption('Cat'),
                            isSelected: _selectedPetType == 'Cat',
                            onTap: () =>
                                setState(() => _selectedPetType = 'Cat'),
                          ),
                          _InlineChoiceChip(
                            label: copy.petFormOption('Dog'),
                            isSelected: _selectedPetType == 'Dog',
                            onTap: () =>
                                setState(() => _selectedPetType = 'Dog'),
                          ),
                          _InlineChoiceChip(
                            label: copy.petFormOption('Bird'),
                            isSelected: _selectedPetType == 'Bird',
                            onTap: () =>
                                setState(() => _selectedPetType = 'Bird'),
                          ),
                          _InlineChoiceChip(
                            label: copy.petFormOption('Other'),
                            isSelected: _selectedPetType == 'Other',
                            onTap: () =>
                                setState(() => _selectedPetType = 'Other'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownField(
                        label: copy.breed,
                        value: _selectedBreed,
                        items: const [
                          'Mixed',
                          'Persian',
                          'Siamese',
                          'Golden Retriever',
                          'German Shepherd',
                        ],
                        itemLabelBuilder: copy.petFormOption,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedBreed = val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownField(
                        label: copy.color,
                        value: _selectedColor,
                        items: const [
                          'Brown',
                          'Black',
                          'White',
                          'Gray',
                          'Mixed',
                        ],
                        itemLabelBuilder: copy.petFormOption,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedColor = val);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        copy.gender,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _InlineChoiceChip(
                            label: copy.petFormOption('Male'),
                            isSelected: _selectedGender == 'Male',
                            onTap: () =>
                                setState(() => _selectedGender = 'Male'),
                          ),
                          _InlineChoiceChip(
                            label: copy.petFormOption('Female'),
                            isSelected: _selectedGender == 'Female',
                            onTap: () =>
                                setState(() => _selectedGender = 'Female'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      PetTextField(
                        label: copy.weightKg,
                        controller: _weightController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        copy.size,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _InlineChoiceChip(
                            label: copy.petFormOption('Small'),
                            isSelected: _selectedSize == 'Small',
                            onTap: () =>
                                setState(() => _selectedSize = 'Small'),
                          ),
                          _InlineChoiceChip(
                            label: copy.petFormOption('Medium'),
                            isSelected: _selectedSize == 'Medium',
                            onTap: () =>
                                setState(() => _selectedSize = 'Medium'),
                          ),
                          _InlineChoiceChip(
                            label: copy.petFormOption('Large'),
                            isSelected: _selectedSize == 'Large',
                            onTap: () =>
                                setState(() => _selectedSize = 'Large'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownField(
                        label: copy.behavior,
                        value: _selectedBehavior,
                        items: const ['Calm', 'Playful', 'Aggressive', 'Shy'],
                        itemLabelBuilder: copy.petFormOption,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedBehavior = val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownField(
                        label: copy.healthStatusLabel,
                        value: _selectedHealthStatus,
                        items: const [
                          'Healthy',
                          'Needs care',
                          'Recovering',
                          'Special needs',
                        ],
                        itemLabelBuilder: copy.petFormOption,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedHealthStatus = val);
                          }
                        },
                      ),
                      if (!_isForAdoption) ...[
                        const SizedBox(height: 12),
                        PetTextField(
                          label: copy.price,
                          controller: _priceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      PetTextField(
                        label: copy.aboutSpecialMarks,
                        controller: _aboutController,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 12),
                      PetTextField(
                        label: copy.favorites,
                        controller: _favoritesController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        copy.animalPhotos,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AddPhotosBox(
                        onTap: _pickImages,
                        photoCount: _selectedImageUrls.length,
                      ),
                      if (_selectedImageUrls.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(_selectedImageUrls.length, (
                            index,
                          ) {
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 86,
                                  height: 86,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFFE8E0D7),
                                    ),
                                  ),
                                  child: AppMedia(
                                    imageUrl: _selectedImageUrls[index],
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                Positioned(
                                  top: -8,
                                  right: -8,
                                  child: GestureDetector(
                                    onTap: () => _removeImageAt(index),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF7E452A,
                                        ).withValues(alpha: 1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          copy.choosePhotosHint,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.black54, height: 1.4),
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: plum,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
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
                              : Text(
                                  copy.save,
                                  style: const TextStyle(
                                    fontSize: 14,
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

class _InlineChoiceChip extends StatelessWidget {
  const _InlineChoiceChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7E452A) : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF7E452A)
                : const Color(0xFFE8E0D7),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
