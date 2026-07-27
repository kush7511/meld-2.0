import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_avatar.dart';
import '../data/chat_models.dart';
import '../data/chat_repository.dart';
import 'message_bubble.dart';
import 'typing_indicator.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  static const routeName = '/chat';

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final contact = ref.watch(selectedChatProvider);
    final messages = ref.watch(messagesProvider);

    ref.listen<List<ChatMessage>>(messageControllerProvider, (previous, next) {
      if ((previous?.length ?? 0) < next.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            AppAvatar(
              name: contact.name,
              radius: 20,
              isOnline: contact.isOnline,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam_rounded),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call_rounded)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 14),
              itemCount: messages.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) return const _DateSeparator(label: 'Today');
                if (index == messages.length + 1) {
                  return contact.isTyping
                      ? const TypingIndicator()
                      : const SizedBox(height: 10);
                }
                final message = messages[index - 1];
                return MessageBubble(
                  message: message,
                  onReact: () => ref
                      .read(messageControllerProvider.notifier)
                      .react(message.id, '+1'),
                  onEdit: () => _showEditDialog(context, message),
                  onDeleteForMe: () => ref
                      .read(messageControllerProvider.notifier)
                      .deleteForMe(message.id),
                  onDeleteForEveryone: () => ref
                      .read(messageControllerProvider.notifier)
                      .deleteForEveryone(message.id),
                  onTogglePinned: () => ref
                      .read(messageControllerProvider.notifier)
                      .togglePinned(message.id),
                  onToggleBookmark: () => ref
                      .read(messageControllerProvider.notifier)
                      .toggleBookmark(message.id),
                  onToggleStar: () => ref
                      .read(messageControllerProvider.notifier)
                      .toggleStar(message.id),
                );
              },
            ),
          ),
          const _Composer(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  Future<void> _showEditDialog(BuildContext context, ChatMessage message) async {
    final controller = TextEditingController(text: message.text);
    final updated = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit message'),
        content: TextField(
          controller: controller,
          autofocus: true,
          minLines: 1,
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (updated == null || !mounted) return;
    ref.read(messageControllerProvider.notifier).editMessage(message.id, updated);
  }
}

class _DateSeparator extends StatelessWidget {
  const _DateSeparator({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.black45,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}

class _Composer extends ConsumerStatefulWidget {
  const _Composer();

  @override
  ConsumerState<_Composer> createState() => _ComposerState();
}

class _ComposerState extends ConsumerState<_Composer> {
  final _controller = TextEditingController();

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
                controller: _controller,
                minLines: 1,
                maxLines: 4,
                onChanged: (value) => ref
                    .read(conversationControllerProvider.notifier)
                    .updateTyping('1', value.trim().isNotEmpty),
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
              onPressed: _send,
              child: const Icon(Icons.send_rounded),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text;
    ref.read(messageControllerProvider.notifier).sendText(text);
    ref.read(conversationControllerProvider.notifier).updateTyping('1', false);
    _controller.clear();
  }
}
