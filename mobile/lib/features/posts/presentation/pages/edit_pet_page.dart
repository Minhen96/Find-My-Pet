import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong2.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/pets_provider.dart';
import '../../auth/presentation/widgets/auth_field_label.dart';
import '../../auth/presentation/widgets/auth_text_field.dart';
import '../models/pet.dart';

class EditPetPage extends ConsumerStatefulWidget {
  final Pet pet;
  const EditPetPage({super.key, required this.pet});

  @override
  ConsumerState<EditPetPage> createState() => _EditPetPageState();
}

class _EditPetPageState extends ConsumerState<EditPetPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _colorController;
  late TextEditingController _descriptionController;
  
  late PetType _selectedType;
  late PetStatus _selectedStatus;
  LatLng? _pickedLocation;
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet.name);
    _breedController = TextEditingController(text: widget.pet.breed);
    _colorController = TextEditingController(text: widget.pet.color);
    _descriptionController = TextEditingController(text: widget.pet.description);
    _selectedType = widget.pet.type;
    _selectedStatus = widget.pet.status;
    _pickedLocation = LatLng(widget.pet.location.coordinates[1], widget.pet.location.coordinates[0]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _colorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final petData = {
        'name': _nameController.text.trim(),
        'type': _selectedType.name.toUpperCase(),
        'status': _selectedStatus.name.toUpperCase(),
        'breed': _breedController.text.trim(),
        'color': _colorController.text.trim(),
        'description': _descriptionController.text.trim(),
        'latitude': _pickedLocation?.latitude,
        'longitude': _pickedLocation?.longitude,
      };

      await ref.read(petsProvider.notifier).updatePet(widget.pet.id, petData, _selectedImages);
      
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update post: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Edit Post',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthFieldLabel(text: 'Pet Name'),
                const SizedBox(height: 8),
                AuthTextField(
                  controller: _nameController,
                  hint: 'Buddy',
                  icon: Icons.pets,
                  enabled: !_isSubmitting,
                ),
                
                const SizedBox(height: 20),
                
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AuthFieldLabel(text: 'Type'),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<PetType>(
                            value: _selectedType,
                            decoration: _dropdownDecoration(),
                            items: PetType.values.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type.name.toUpperCase()),
                              );
                            }).toList(),
                            onChanged: _isSubmitting ? null : (v) => setState(() => _selectedType = v!),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AuthFieldLabel(text: 'Status'),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<PetStatus>(
                            value: _selectedStatus,
                            decoration: _dropdownDecoration(),
                            items: PetStatus.values.map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(status.name.toUpperCase()),
                              );
                            }).toList(),
                            onChanged: _isSubmitting ? null : (v) => setState(() => _selectedStatus = v!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                const AuthFieldLabel(text: 'Breed'),
                const SizedBox(height: 8),
                AuthTextField(
                  controller: _breedController,
                  hint: 'Golden Retriever',
                  icon: Icons.category,
                  enabled: !_isSubmitting,
                ),
                
                const SizedBox(height: 20),
                
                const AuthFieldLabel(text: 'Color'),
                const SizedBox(height: 8),
                AuthTextField(
                  controller: _colorController,
                  hint: 'Golden/Cream',
                  icon: Icons.color_lens,
                  enabled: !_isSubmitting,
                ),
                
                const SizedBox(height: 20),
                
                const AuthFieldLabel(text: 'Add More Photos'),
                const SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _selectedImages.length) {
                        return GestureDetector(
                          onTap: _pickImages,
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: AppColors.divider.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.add_a_photo, color: AppColors.textHint),
                          ),
                        );
                      }
                      return Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: FileImage(File(_selectedImages[index].path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: 4,
                              top: 4,
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedImages.removeAt(index)),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 20),
                
                const AuthFieldLabel(text: 'Location'),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.location_on, color: Colors.red),
                  title: Text(
                    _pickedLocation == null
                        ? 'Select on Map'
                        : 'Location Selected (${_pickedLocation!.latitude.toStringAsFixed(4)}, ${_pickedLocation!.longitude.toStringAsFixed(4)})',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final result = await context.push<LatLng>('/location-picker');
                    if (result != null) {
                      setState(() {
                        _pickedLocation = result;
                      });
                    }
                  },
                ),
                
                const SizedBox(height: 20),
                
                const AuthFieldLabel(text: 'Description'),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  enabled: !_isSubmitting,
                  decoration: InputDecoration(
                    hintText: 'Describe the pet...',
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.cardBorder),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primary,
                      shape: BorderRadius.circular(12),
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator()
                        : const Text('Update Post'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.cardBorder),
      ),
    );
  }
}
