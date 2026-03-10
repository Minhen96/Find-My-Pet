import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/pets_provider.dart';
import '../../auth/presentation/widgets/auth_field_label.dart';
import '../../auth/presentation/widgets/auth_text_field.dart';
import '../models/pet.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _colorController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  PetType _selectedType = PetType.dog;
  PetStatus _selectedStatus = PetStatus.lost;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _colorController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
        // For now, location and images are hardcoded or left empty as we haven't integrated maps/picking fully here
        'lastSeenLocation': {'latitude': 3.1390, 'longitude': 101.6869}, // Kuala Lumpur
      };

      await ref.read(petsProvider.notifier).createPet(petData);
      
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create post: $e')),
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
          'Post a Pet',
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
                      shape: BorderRadius.circular(12),
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
