import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TeamLogo extends StatelessWidget {
  final String? url;
  final double size;

  const TeamLogo({super.key, this.url, this.size = 36});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return _placeholder();
    }
    return CachedNetworkImage(
      imageUrl: url!,
      width: size,
      height: size,
      fit: BoxFit.contain,
      placeholder: (_, __) => _placeholder(),
      errorWidget: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() => SizedBox(
        width: size,
        height: size,
        child: Icon(Icons.sports_soccer, size: size * 0.7, color: Colors.grey),
      );
}

class LeagueLogo extends StatelessWidget {
  final String? url;
  final double size;

  const LeagueLogo({super.key, this.url, this.size = 28});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: Icon(Icons.emoji_events, size: size * 0.7, color: Colors.grey),
      );
    }
    return CachedNetworkImage(
      imageUrl: url!,
      width: size,
      height: size,
      fit: BoxFit.contain,
      placeholder: (_, __) => SizedBox(width: size, height: size),
      errorWidget: (_, __, ___) => SizedBox(
        width: size,
        height: size,
        child: Icon(Icons.emoji_events, size: size * 0.7, color: Colors.grey),
      ),
    );
  }
}

class FlagImage extends StatelessWidget {
  final String? url;
  final double width;
  final double height;

  const FlagImage({super.key, this.url, this.width = 24, this.height = 16});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) return const SizedBox.shrink();
    return CachedNetworkImage(
      imageUrl: url!,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorWidget: (_, __, ___) => const SizedBox.shrink(),
    );
  }
}
