import 'package:flutter/material.dart';

import '../../../core/widgets/app_avatar.dart';
import '../data/chat_models.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({required this.chat, required this.onTap, super.key});

  final ChatContact chat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: AppAvatar(name: chat.name, isOnline: chat.isOnline),
      title: Row(
        children: [
          Expanded(
            child: Text(
              chat.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          if (chat.isPinned)
            Icon(Icons.push_pin_rounded, size: 15, color: primary),
        ],
      ),
      subtitle: Text(
        chat.isTyping ? 'typing...' : chat.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: chat.isTyping ? primary : Colors.black54,
          fontWeight: chat.isTyping ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            chat.time,
            style: const TextStyle(fontSize: 12, color: Colors.black45),
          ),
          const SizedBox(height: 7),
          if (chat.unreadCount > 0)
            Badge(backgroundColor: primary, label: Text('${chat.unreadCount}'))
          else
            const Icon(Icons.done_all_rounded, size: 18, color: Colors.black26),
        ],
      ),
      onTap: onTap,
    );
  }
}
