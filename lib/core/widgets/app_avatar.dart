import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    required this.name,
    this.imageUrl,
    this.radius = 26,
    this.isOnline = false,
    super.key,
  });

  final String name;
  final String? imageUrl;
  final double radius;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          backgroundImage: imageUrl == null ? null : NetworkImage(imageUrl!),
          child: imageUrl == null
              ? Text(
                  initial,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                )
              : null,
        ),
        if (isOnline)
          Positioned(
            right: 1,
            bottom: 1,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
