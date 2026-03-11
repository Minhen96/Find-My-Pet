import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/profile/data/repositories/pet_profile_repository.dart';
import 'package:mobile/features/profile/presentation/providers/my_pet_profiles_provider.dart';
import 'package:mobile/features/posts/data/models/post.dart'; // For AnimalType

class AddPetProfilePage extends ConsumerStatefulWidget {
  const AddPetProfilePage({super.key});

  @override
  ConsumerState<AddPetProfilePage> createState() => _AddPetProfilePageState();
}

class _AddPetProfilePageState extends ConsumerState<AddPetProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _markingsController = TextEditingController();
  final _healthController = TextEditingController();
  final _microchipController = TextEditingController();
  final _colorController = TextEditingController();

  XFile? _image;
  Uint8List? _mainImageBytes;
  final List<XFile> _additionalImages = [];
  final List<Uint8List> _additionalImagesBytes = [];
  bool _isLoading = false;
  String _gender = 'Male';
  AnimalType _animalType = AnimalType.dog;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickMainImage() async {
    final XFile? selected = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (selected != null) {
      final bytes = await selected.readAsBytes();
      setState(() {
        _image = selected;
        _mainImageBytes = bytes;
      });
    }
  }

  Future<void> _pickAdditionalImages() async {
    final List<XFile> selected = await _picker.pickMultiImage();
    if (selected.isNotEmpty) {
      for (var file in selected) {
        final bytes = await file.readAsBytes();
        setState(() {
          _additionalImages.add(file);
          _additionalImagesBytes.add(bytes);
        });
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one photo')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final profileData = {
        'name': _nameController.text.trim(),
        'type': _animalType.name.toUpperCase(),
        'breed': _breedController.text.trim(),
        'age': int.tryParse(_ageController.text.trim()),
        'gender': _gender,
        'color': _colorController.text.trim(),
        'markings': _markingsController.text.trim(),
        'healthNotes': _healthController.text.trim(),
        'microchipId': _microchipController.text.trim(),
      };

      final allImages = [_image!, ..._additionalImages];

      final repository = ref.read(petProfileRepositoryProvider);
      await repository.createPetProfile(profileData, allImages);
      
      // Refresh the profiles list
      ref.invalidate(myPetProfilesProvider);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet profile created successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _markingsController.dispose();
    _healthController.dispose();
    _microchipController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Add New Pet',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _submit,
            child: Text(
              'Save',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: _isLoading ? AppColors.textHint : AppColors.primary,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Photo Upload Section ---
                    GestureDetector(
                      onTap: _pickMainImage,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            style: BorderStyle.solid,
                          ),
                          image: _mainImageBytes != null
                              ? DecorationImage(
                                  image: MemoryImage(_mainImageBytes!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _mainImageBytes == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 40,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Upload Main Photo',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 80,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          GestureDetector(
                            onTap: _pickAdditionalImages,
                            child: Container(
                              width: 80,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                              ),
                              child: Icon(
                                Icons.add_photo_alternate_outlined,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          ..._additionalImagesBytes.map(
                            (bytes) => Container(
                              width: 80,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: MemoryImage(bytes),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                    _buildSectionTitle('Basic Information'),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'Pet Name',
                      'What is your pet\'s name?',
                      _nameController,
                    ),
                    const SizedBox(height: 16),
                    _buildAnimalTypeSelector(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            'Breed',
                            'e.g. Golden Retriever',
                            _breedController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            'Age',
                            'e.g. 2',
                            _ageController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'Color',
                      'e.g. Golden, Brown',
                      _colorController,
                    ),
                    const SizedBox(height: 16),
                    _buildSectionTitle('Gender'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildChoiceChip('Male', Icons.male),
                        const SizedBox(width: 12),
                        _buildChoiceChip('Female', Icons.female),
                      ],
                    ),

                    const SizedBox(height: 32),
                    _buildSectionTitle('Other Details'),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'Unique Markings',
                      'e.g. White patch on left paw',
                      _markingsController,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'Health Notes',
                      'Any allergies or conditions?',
                      _healthController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'Microchip ID',
                      '15-digit number',
                      _microchipController,
                      suffixIcon: Icons.qr_code_scanner,
                    ),

                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isLoading)
                            const Icon(Icons.refresh, size: 20)
                          else
                            const Icon(Icons.check_circle_outline, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            _isLoading ? 'SUBMITTING...' : 'CREATE PET PROFILE',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.inter(
                            color: AppColors.textHint,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAnimalTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Animal Type',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<AnimalType>(
          initialValue: _animalType,
          items: AnimalType.values.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type.name.toUpperCase()),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) setState(() => _animalType = value);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    IconData? suffixIcon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.inter(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              color: AppColors.textHint,
              fontSize: 14,
            ),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: AppColors.primary)
                : null,
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'This field is required' : null,
        ),
      ],
    );
  }

  Widget _buildChoiceChip(String label, IconData icon) {
    final isSelected = _gender == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _gender = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.textHint.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
