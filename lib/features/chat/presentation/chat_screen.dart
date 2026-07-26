import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_avatar.dart';
import '../data/chat_repository.dart';
import 'message_bubble.dart';
import 'typing_indicator.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  static const routeName = '/chat';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contact = ref.watch(selectedChatProvider);
    final messages = ref.watch(messagesProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            AppAvatar(name: contact.name, radius: 20, isOnline: contact.isOnline),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  Text(
                    contact.isTyping ? 'typing...' : 'online',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.videocam_rounded)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call_rounded)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 14),
              itemCount: messages.length + 1,
              itemBuilder: (context, index) {
                if (index == messages.length) return const TypingIndicator();
                return MessageBubble(message: messages[index]);
              },
            ),
          ),
          const _Composer(),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
        color: Colors.white,
        child: Row(
          children: [
            IconButton(
              tooltip: 'Attach',
              onPressed: () {},
              icon: const Icon(Icons.add_rounded),
            ),
            Expanded(
              child: TextField(
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Message',
                  filled: true,
                  fillColor: const Color(0xFFF4FBF5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton.small(
              heroTag: 'send-message',
              onPressed: () {},
              child: const Icon(Icons.send_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
