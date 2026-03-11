import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/posts_provider.dart';
import 'package:mobile/features/profile/presentation/providers/my_pet_profiles_provider.dart';
import 'package:mobile/features/auth/presentation/widgets/auth_field_label.dart';
import 'package:mobile/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:mobile/features/posts/data/models/post.dart';
import 'package:mobile/features/profile/data/models/pet_profile.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final _breedController = TextEditingController();
  final _colorController = TextEditingController();
  final _descriptionController = TextEditingController();

  PostType _selectedType = PostType.lost;
  AnimalType _selectedAnimalType = AnimalType.dog;
  PetProfile? _selectedPetProfile;
  LatLng? _pickedLocation;
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  @override
  void dispose() {
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
    if (_pickedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please pick a location on the map.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final postData = {
        'type': _selectedType.name.toUpperCase(),
        'animalType': _selectedAnimalType.name.toUpperCase(),
        'petProfileId': _selectedPetProfile?.id,
        'breed': _breedController.text.trim().isEmpty ? null : _breedController.text.trim(),
        'color': _colorController.text.trim().isEmpty ? null : _colorController.text.trim(),
        'description': _descriptionController.text.trim(),
        'latitude': _pickedLocation!.latitude,
        'longitude': _pickedLocation!.longitude,
      };

      await ref.read(postsProvider.notifier).createPost(postData, _selectedImages);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to create post: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final myProfilesState = ref.watch(myPetProfilesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Post an Update',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthFieldLabel(text: 'Post Type'),
                const SizedBox(height: 8),
                DropdownButtonFormField<PostType>(
                  initialValue: _selectedType,
                  decoration: _dropdownDecoration(),
                  items: PostType.values.where((t) => t != PostType.moment).map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: _isSubmitting
                      ? null
                      : (v) => setState(() => _selectedType = v!),
                ),

                const SizedBox(height: 20),

                const AuthFieldLabel(text: 'Link to My Pet (Optional)'),
                const SizedBox(height: 8),
                myProfilesState.when(
                  data: (profiles) => DropdownButtonFormField<PetProfile?>(
                    initialValue: _selectedPetProfile,
                    decoration: _dropdownDecoration().copyWith(
                      hintText: 'Select a pet profile',
                    ),
                    items: [
                      const DropdownMenuItem<PetProfile?>(
                        value: null,
                        child: Text('Not linked to my pet'),
                      ),
                      ...profiles.map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(p.name),
                          )),
                    ],
                    onChanged: _isSubmitting
                        ? null
                        : (v) {
                            setState(() {
                              _selectedPetProfile = v;
                              if (v != null) {
                                _breedController.text = v.breed;
                                _colorController.text = v.color;
                                // Automatically sync animal type if available
                                // _selectedAnimalType = ... (v.type if we had it in PetProfile)
                              }
                            });
                          },
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, __) => Text('Error loading profiles: $e'),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AuthFieldLabel(text: 'Animal Type'),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<AnimalType>(
                            initialValue: _selectedAnimalType,
                            decoration: _dropdownDecoration(),
                            items: AnimalType.values.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type.name.toUpperCase()),
                              );
                            }).toList(),
                            onChanged: _isSubmitting
                                ? null
                                : (v) => setState(() => _selectedAnimalType = v!),
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

                const AuthFieldLabel(text: 'Photos'),
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
                              color: AppColors.divider.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.add_a_photo,
                              color: AppColors.textHint,
                            ),
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
                                onTap: () => setState(
                                  () => _selectedImages.removeAt(index),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
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
                      color: _pickedLocation == null
                          ? AppColors.textHint
                          : AppColors.textPrimary,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final result = await context.push<LatLng>(
                      '/location-picker',
                    );
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
                    hintText: 'Describe the pet or sighting details...',
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.cardBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator()
                        : Text(
                            'Post Now',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
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
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.cardBorder),
      ),
    );
  }
}
