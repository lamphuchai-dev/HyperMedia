import 'package:flutter/widgets.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/data/models/models.dart';


class GenreCard extends StatelessWidget {
  const GenreCard({super.key, required this.genre, required this.onTap});
  final Genre genre;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (genre.title == null || genre.url == null) return const SizedBox();
    final colorScheme = context.colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
            color: colorScheme.surface, borderRadius: BorderRadius.circular(4)),
        child: Text(genre.title!),
      ),
    );
  }
}
