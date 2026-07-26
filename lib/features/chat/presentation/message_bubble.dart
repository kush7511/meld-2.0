import 'package:flutter/material.dart';

import '../data/chat_models.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({required this.message, super.key});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final alignment = message.isMine ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = message.isMine ? primary : Colors.white;
    final textColor = message.isMine ? Colors.white : Colors.black87;

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
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
              if (message.type == MessageType.text)
                Text(message.text, style: TextStyle(color: textColor, height: 1.35)),
              if (message.type == MessageType.image) ImageMessage(message: message),
              if (message.type == MessageType.voice)
                VoiceMessage(message: message, foregroundColor: textColor),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.time,
                    style: TextStyle(
                      color: message.isMine ? Colors.white70 : Colors.black45,
                      fontSize: 11,
                    ),
                  ),
                  if (message.isMine) ...[
                    const SizedBox(width: 5),
                    Icon(
                      Icons.done_all_rounded,
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
    );
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
          errorBuilder: (_, _, _) => Container(
            color: const Color(0xFFE8F1EA),
            child: const Center(child: Icon(Icons.image_not_supported_rounded)),
          ),
        ),
      ),
    );
  }
}
