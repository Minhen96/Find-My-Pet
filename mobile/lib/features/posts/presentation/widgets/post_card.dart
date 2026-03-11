import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/features/posts/data/models/post.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/interactions_provider.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interactionsAsync = ref.watch(interactionsProvider(post.id));
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
                  backgroundColor: AppColors.primary.withValues(alpha: 0.3),
                  backgroundImage: post.poster?.email != null
                      ? NetworkImage(
                          'https://ui-avatars.com/api/?name=${post.poster!.displayName}&background=B3DFDC&color=0F172A',
                        )
                      : null,
                  child: post.poster?.email == null
                      ? const Icon(Icons.person, color: AppColors.primaryDark)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.poster?.displayName ?? 'Anonymous',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${post.createdAt.day}/${post.createdAt.month}/${post.createdAt.year} • ${post.petProfile?.name ?? post.breed ?? post.animalType?.name.toUpperCase() ?? "Unknown"}',
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
            child: post.images.isNotEmpty
                ? PageView.builder(
                    itemCount: post.images.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        post.images[index],
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
                          post.type,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        post.type.name.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(
                            post.type,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        post.petProfile?.name ?? post.animalType?.name.toUpperCase() ?? 'UNNAMED',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  post.description ?? 'No description provided.',
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
                    interactionsAsync.when(
                      data: (data) {
                        final likesCount = data['likesCount'] as int;
                        return Row(
                          children: [
                            _ActionButton(
                              icon: Icons
                                  .favorite_border, // TODO: Add liked status
                              onPressed: () => ref
                                  .read(interactionsProvider(post.id).notifier)
                                  .toggleLike(),
                            ),
                            Text(
                              '$likesCount',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => const SizedBox(
                        width: 40,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      error: (_, __) => const Icon(Icons.error_outline),
                    ),
                    const SizedBox(width: 12),
                    _ActionButton(
                      icon: Icons.chat_bubble_outline,
                      onPressed: () =>
                          context.push('/post-details', extra: post),
                    ),
                    _ActionButton(
                      icon: Icons.share_outlined,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Social sharing coming soon!',
                            ),
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () =>
                          context.push('/post-details', extra: post),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.15,
                        ),
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

  Color _getStatusColor(PostType type) {
    switch (type) {
      case PostType.lost:
        return Colors.redAccent;
      case PostType.found:
        return Colors.green;
      case PostType.sighted:
      case PostType.stray:
        return Colors.orange;
      case PostType.rescued:
        return AppColors.primaryDark;
      case PostType.moment:
        return AppColors.primary;
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
