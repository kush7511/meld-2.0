import 'package:flutter/material.dart';

import '../../../core/widgets/app_avatar.dart';
import '../data/chat_models.dart';

class StoryRow extends StatelessWidget {
  const StoryRow({required this.contacts, super.key});

  final List<ChatContact> contacts;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 94,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemBuilder: (context, index) {
          if (index == 0) {
            return const _StoryItem(name: 'Your story', icon: Icons.add_rounded);
          }
          final contact = contacts[index - 1];
          return _StoryItem(name: contact.name, isOnline: contact.isOnline);
        },
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemCount: contacts.length + 1,
      ),
    );
  }
}

class _StoryItem extends StatelessWidget {
  const _StoryItem({required this.name, this.icon, this.isOnline = false});

  final String name;
  final IconData? icon;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        children: [
          if (icon == null)
            AppAvatar(name: name, radius: 28, isOnline: isOnline)
          else
            CircleAvatar(
              radius: 28,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(icon, color: Colors.white),
            ),
          const SizedBox(height: 8),
          Text(
            name.split(' ').first,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
