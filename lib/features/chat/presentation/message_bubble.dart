import 'package:flutter/material.dart';

import '../data/chat_models.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    this.onReact,
    this.onEdit,
    this.onDeleteForMe,
    this.onDeleteForEveryone,
    this.onTogglePinned,
    this.onToggleBookmark,
    this.onToggleStar,
    super.key,
  });

  final ChatMessage message;
  final VoidCallback? onReact;
  final VoidCallback? onEdit;
  final VoidCallback? onDeleteForMe;
  final VoidCallback? onDeleteForEveryone;
  final VoidCallback? onTogglePinned;
  final VoidCallback? onToggleBookmark;
  final VoidCallback? onToggleStar;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final alignment = message.isMine
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final bubbleColor = message.isMine ? primary : Colors.white;
    final textColor = message.isMine ? Colors.white : Colors.black87;

    if (message.deletedForMe) return const SizedBox.shrink();

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: PopupMenuButton<MessageAction>(
          tooltip: 'Message actions',
          onSelected: (action) => _handleAction(context, action),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: MessageAction.reply,
              child: Text('Reply'),
            ),
            const PopupMenuItem(
              value: MessageAction.copy,
              child: Text('Copy'),
            ),
            if (message.isMine)
              const PopupMenuItem(
                value: MessageAction.edit,
                child: Text('Edit'),
              ),
            const PopupMenuItem(
              value: MessageAction.react,
              child: Text('React'),
            ),
            PopupMenuItem(
              value: MessageAction.pin,
              child: Text(message.isPinned ? 'Unpin' : 'Pin'),
            ),
            PopupMenuItem(
              value: MessageAction.bookmark,
              child: Text(message.isBookmarked ? 'Remove bookmark' : 'Bookmark'),
            ),
            PopupMenuItem(
              value: MessageAction.star,
              child: Text(message.isStarred ? 'Unstar' : 'Star'),
            ),
            const PopupMenuItem(
              value: MessageAction.deleteForMe,
              child: Text('Delete for me'),
            ),
            if (message.isMine)
              const PopupMenuItem(
                value: MessageAction.deleteForEveryone,
                child: Text('Delete for everyone'),
              ),
          ],
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(message.isMine ? 20 : 6),
                bottomRight: Radius.circular(message.isMine ? 6 : 20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .05),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.type == MessageType.text ||
                    message.deletedForEveryone)
                  Text(
                    message.text,
                    style: TextStyle(color: textColor, height: 1.35),
                  ),
                if (message.type == MessageType.image &&
                    !message.deletedForEveryone)
                  ImageMessage(message: message),
                if (message.type == MessageType.voiceNote &&
                    !message.deletedForEveryone)
                  VoiceMessage(message: message, foregroundColor: textColor),
                if (message.reactions.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    message.reactions.values.join(' '),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (message.isPinned || message.isBookmarked || message.isStarred) ...[
                      Icon(
                        message.isPinned
                            ? Icons.push_pin_rounded
                            : message.isStarred
                                ? Icons.star_rounded
                                : Icons.bookmark_rounded,
                        size: 14,
                        color: message.isMine ? Colors.white70 : Colors.black45,
                      ),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      message.editedAt == null
                          ? message.time
                          : '${message.time} - edited',
                      style: TextStyle(
                        color: message.isMine ? Colors.white70 : Colors.black45,
                        fontSize: 11,
                      ),
                    ),
                    if (message.isMine) ...[
                      const SizedBox(width: 5),
                      Icon(
                        _statusIcon,
                        size: 16,
                        color: message.isRead ? Colors.white : Colors.white60,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData get _statusIcon {
    switch (message.status) {
      case MessageDeliveryStatus.sending:
        return Icons.schedule_rounded;
      case MessageDeliveryStatus.sent:
        return Icons.done_rounded;
      case MessageDeliveryStatus.delivered:
      case MessageDeliveryStatus.read:
        return Icons.done_all_rounded;
      case MessageDeliveryStatus.failed:
        return Icons.error_outline_rounded;
    }
  }

  void _handleAction(BuildContext context, MessageAction action) {
    switch (action) {
      case MessageAction.react:
        onReact?.call();
        break;
      case MessageAction.edit:
        onEdit?.call();
        break;
      case MessageAction.deleteForMe:
        onDeleteForMe?.call();
        break;
      case MessageAction.deleteForEveryone:
        onDeleteForEveryone?.call();
        break;
      case MessageAction.pin:
        onTogglePinned?.call();
        break;
      case MessageAction.bookmark:
        onToggleBookmark?.call();
        break;
      case MessageAction.star:
        onToggleStar?.call();
        break;
      case MessageAction.copy:
      case MessageAction.reply:
      case MessageAction.forward:
      case MessageAction.share:
      case MessageAction.report:
      case MessageAction.save:
      case MessageAction.translate:
      case MessageAction.scheduleSend:
      case MessageAction.search:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${action.name} is ready for integration.')),
        );
    }
  }
}

class VoiceMessage extends StatelessWidget {
  const VoiceMessage({
    required this.message,
    required this.foregroundColor,
    super.key,
  });

  final ChatMessage message;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final seconds = message.voiceDuration?.inSeconds ?? 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: foregroundColor.withValues(alpha: .16),
          child: Icon(Icons.play_arrow_rounded, color: foregroundColor),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: .62,
              minHeight: 6,
              backgroundColor: foregroundColor.withValues(alpha: .18),
              color: foregroundColor,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '0:${seconds.toString().padLeft(2, '0')}',
          style: TextStyle(color: foregroundColor, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class ImageMessage extends StatelessWidget {
  const ImageMessage({required this.message, super.key});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: Image.network(
          message.imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: const Color(0xFFE8F1EA),
            child: const Center(child: Icon(Icons.image_not_supported_rounded)),
          ),
        ),
      ),
    );
  }
}
