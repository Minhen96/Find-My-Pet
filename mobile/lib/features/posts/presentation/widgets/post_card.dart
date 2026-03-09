import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../data/models/pet.dart';

class PostCard extends StatelessWidget {
  final Pet pet;

  const PostCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 0.5),
          bottom: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary.withOpacity(0.3),
                  backgroundImage: pet.poster?.email != null
                      ? NetworkImage(
                          'https://ui-avatars.com/api/?name=${pet.poster!.fullName}&background=B3DFDC&color=0F172A',
                        )
                      : null,
                  child: pet.poster?.email == null
                      ? const Icon(Icons.person, color: AppColors.primaryDark)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.poster?.fullName ?? 'Anonymous',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${pet.createdAt.day}/${pet.createdAt.month}/${pet.createdAt.year} • ${pet.breed}',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onPressed: () {},
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),

          // Image Carousel (Placeholder if empty)
          AspectRatio(
            aspectRatio: 1,
            child: pet.images.isNotEmpty
                ? PageView.builder(
                    itemCount: pet.images.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        pet.images[index],
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Container(
                    color: AppColors.inputBackground,
                    child: const Icon(
                      Icons.pets,
                      size: 64,
                      color: AppColors.primary,
                    ),
                  ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          pet.status,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        pet.status.name.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(pet.status).withOpacity(0.1),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${pet.type.name.toUpperCase()} - ${pet.color}',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  pet.description ?? 'No description provided.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // Actions
                const Divider(height: 1, color: AppColors.divider),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _ActionButton(
                      icon: Icons.favorite_border,
                      onPressed: () {},
                    ),
                    _ActionButton(
                      icon: Icons.chat_bubble_outline,
                      onPressed: () {},
                    ),
                    _ActionButton(icon: Icons.share_outlined, onPressed: () {}),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary.withOpacity(0.15),
                        foregroundColor: AppColors.textPrimary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'View Details',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(PetStatus status) {
    switch (status) {
      case PetStatus.LOST:
        return Colors.redAccent;
      case PetStatus.FOUND:
        return Colors.green;
      case PetStatus.STRAY:
        return Colors.orange;
      case PetStatus.RESCUED:
        return AppColors.primaryDark;
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ActionButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 22, color: AppColors.textSecondary),
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
    );
  }
}
