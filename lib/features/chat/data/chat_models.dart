enum MessageType { text, voice, image }

class ChatContact {
  const ChatContact({
    required this.id,
    required this.name,
    required this.handle,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
    required this.isPinned,
    required this.isTyping,
  });

  final String id;
  final String name;
  final String handle;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final bool isPinned;
  final bool isTyping;
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.time,
    required this.isMine,
    required this.type,
    this.isRead = false,
    this.imageUrl,
    this.voiceDuration,
  });

  final String id;
  final String text;
  final String time;
  final bool isMine;
  final bool isRead;
  final MessageType type;
  final String? imageUrl;
  final Duration? voiceDuration;
}

class CallLog {
  const CallLog({
    required this.name,
    required this.time,
    required this.isVideo,
    required this.missed,
  });

  final String name;
  final String time;
  final bool isVideo;
  final bool missed;
}

class GroupRoom {
  const GroupRoom({
    required this.name,
    required this.members,
    required this.topic,
  });

  final String name;
  final int members;
  final String topic;
}
