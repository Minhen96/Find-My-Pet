import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/socket_provider.dart';
import 'package:mobile/features/posts/data/models/post.dart';
import '../providers/interactions_provider.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import '../providers/posts_provider.dart';
import './edit_post_page.dart';

class PostDetailsPage extends ConsumerStatefulWidget {
  final Post post;

  const PostDetailsPage({super.key, required this.post});

  @override
  ConsumerState<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends ConsumerState<PostDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(socketProvider)
          .emit(AppConstants.wsEvents.joinPost, widget.post.id);
    });
  }

  @override
  void dispose() {
    ref
        .read(socketProvider)
        .emit(AppConstants.wsEvents.leavePost, widget.post.id);
    super.dispose();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(postsProvider.notifier).deletePost(widget.post.id);
        if (mounted) {
          Navigator.of(context).pop(); // Go back to feed
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Post deleted')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final interactionsAsync = ref.watch(interactionsProvider(widget.post.id));
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.post.type == PostType.moment
              ? 'Moment Details'
              : 'Post Details',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          if (ref.watch(authProvider).value?.id == widget.post.poster?.id) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              // ignore: deprecated_member_use_from_same_package
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => EditPostPage(post: widget.post)),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _confirmDelete(),
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            if (widget.post.images.isNotEmpty)
              AspectRatio(
                aspectRatio: 1.2,
                child: PageView.builder(
                  itemCount: widget.post.images.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      widget.post.images[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              )
            else
              Container(
                height: 250,
                width: double.infinity,
                color: AppColors.inputBackground,
                child: const Icon(
                  Icons.pets,
                  size: 80,
                  color: AppColors.primary,
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _StatusBadge(type: widget.post.type),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.post.animalType?.name.toUpperCase() ?? "UNKNOWN"} • ${widget.post.breed ?? "Unknown Breed"}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.post.petProfile?.name ?? 'Unnamed',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Color: ${widget.post.color ?? "Unknown"}',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                  Text(
                    'Description',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.post.description ?? 'No description provided.',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    widget.post.type == PostType.moment
                        ? 'Captured Location'
                        : 'Event Location',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 200,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                            widget.post.location?['coordinates']?[1]
                                    ?.toDouble() ??
                                3.139,
                            widget.post.location?['coordinates']?[0]
                                    ?.toDouble() ??
                                101.687,
                          ),
                          initialZoom: 15,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(
                                  widget.post.location?['coordinates']?[1]
                                          ?.toDouble() ??
                                      3.139,
                                  widget.post.location?['coordinates']?[0]
                                          ?.toDouble() ??
                                      101.687,
                                ),
                                width: 40,
                                height: 40,
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),
                  Text(
                    'Comments',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  interactionsAsync.when(
                    data: (data) {
                      final comments = data['comments'] as List<dynamic>? ?? [];
                      if (comments.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'No comments yet. Be the first to say something!',
                            style: GoogleFonts.inter(color: AppColors.textHint),
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: comments.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          final user = comment['user'] ?? {};
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: NetworkImage(
                                  'https://ui-avatars.com/api/?name=${user['displayName'] ?? "User"}',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user['displayName'] ?? 'Anonymous',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      comment['content'] ?? '',
                                      style: GoogleFonts.inter(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, __) => Text('Error loading comments: $e'),
                  ),
                  const SizedBox(height: 12),
                  _CommentInput(postId: widget.post.id),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentInput extends ConsumerStatefulWidget {
  final String postId;
  const _CommentInput({required this.postId});

  @override
  ConsumerState<_CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends ConsumerState<_CommentInput> {
  final _controller = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSending = true);
    try {
      await ref
          .read(interactionsProvider(widget.postId).notifier)
          .addComment(text);
      _controller.clear();
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Add a comment...',
                border: InputBorder.none,
                isDense: true,
              ),
              style: GoogleFonts.inter(fontSize: 14),
              onSubmitted: (_) => _send(),
            ),
          ),
          IconButton(
            icon: _isSending
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send, color: AppColors.primary),
            onPressed: _isSending ? null : _send,
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final PostType type;

  const _StatusBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (type) {
      case PostType.lost:
        color = Colors.redAccent;
        break;
      case PostType.found:
        color = Colors.green;
        break;
      case PostType.moment:
        color = AppColors.primaryDark;
        break;
      case PostType.sighted:
      case PostType.stray:
        color = Colors.orange;
        break;
      case PostType.rescued:
        color = AppColors.primary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        type.name.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
