enum ConversationFolder { inbox, archived, work, family, friends, custom }

enum MessageDeliveryStatus { sending, sent, delivered, read, failed }

enum MessageType {
  text,
  image,
  video,
  document,
  pdf,
  voiceNote,
  audio,
  contact,
  location,
  poll,
  gifPlaceholder,
  stickerPlaceholder,
}

enum ConversationRole { owner, admin, moderator, member }

enum ConversationSetting {
  muted,
  archived,
  blocked,
  favorite,
  customWallpaper,
  customNotificationSound,
}

enum MessageAction {
  reply,
  forward,
  copy,
  edit,
  deleteForMe,
  deleteForEveryone,
  react,
  pin,
  bookmark,
  share,
  report,
  save,
  translate,
  scheduleSend,
  star,
  search,
}

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
    this.isMuted = false,
    this.isArchived = false,
    this.isBlocked = false,
    this.isFavorite = false,
    this.folder = ConversationFolder.inbox,
    this.lastActive,
    this.wallpaperUrl,
    this.notificationSound,
    this.labels = const [],
    this.tags = const [],
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
  final bool isMuted;
  final bool isArchived;
  final bool isBlocked;
  final bool isFavorite;
  final ConversationFolder folder;
  final DateTime? lastActive;
  final String? wallpaperUrl;
  final String? notificationSound;
  final List<String> labels;
  final List<String> tags;

  ChatContact copyWith({
    String? lastMessage,
    String? time,
    int? unreadCount,
    bool? isOnline,
    bool? isPinned,
    bool? isTyping,
    bool? isMuted,
    bool? isArchived,
    bool? isBlocked,
    bool? isFavorite,
    ConversationFolder? folder,
    DateTime? lastActive,
    String? wallpaperUrl,
    String? notificationSound,
    List<String>? labels,
    List<String>? tags,
  }) {
    return ChatContact(
      id: id,
      name: name,
      handle: handle,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
      isPinned: isPinned ?? this.isPinned,
      isTyping: isTyping ?? this.isTyping,
      isMuted: isMuted ?? this.isMuted,
      isArchived: isArchived ?? this.isArchived,
      isBlocked: isBlocked ?? this.isBlocked,
      isFavorite: isFavorite ?? this.isFavorite,
      folder: folder ?? this.folder,
      lastActive: lastActive ?? this.lastActive,
      wallpaperUrl: wallpaperUrl ?? this.wallpaperUrl,
      notificationSound: notificationSound ?? this.notificationSound,
      labels: labels ?? this.labels,
      tags: tags ?? this.tags,
    );
  }
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.time,
    required this.isMine,
    required this.type,
    this.status = MessageDeliveryStatus.sent,
    this.createdAt,
    this.imageUrl,
    this.voiceDuration,
    this.senderId = 'me',
    this.replyToMessageId,
    this.reactions = const {},
    this.isPinned = false,
    this.isBookmarked = false,
    this.isStarred = false,
    this.scheduledAt,
    this.metadata = const {},
    this.deletedForMe = false,
    this.deletedForEveryone = false,
    this.editedAt,
  });

  final String id;
  final String text;
  final String time;
  final bool isMine;
  final MessageDeliveryStatus status;
  final MessageType type;
  final DateTime? createdAt;
  final String? imageUrl;
  final Duration? voiceDuration;
  final String senderId;
  final String? replyToMessageId;
  final Map<String, String> reactions;
  final bool isPinned;
  final bool isBookmarked;
  final bool isStarred;
  final DateTime? scheduledAt;
  final Map<String, Object?> metadata;
  final bool deletedForMe;
  final bool deletedForEveryone;
  final DateTime? editedAt;

  bool get isRead => status == MessageDeliveryStatus.read;

  ChatMessage copyWith({
    String? text,
    String? time,
    bool? isMine,
    MessageDeliveryStatus? status,
    MessageType? type,
    DateTime? createdAt,
    String? imageUrl,
    Duration? voiceDuration,
    String? senderId,
    String? replyToMessageId,
    Map<String, String>? reactions,
    bool? isPinned,
    bool? isBookmarked,
    bool? isStarred,
    DateTime? scheduledAt,
    Map<String, Object?>? metadata,
    bool? deletedForMe,
    bool? deletedForEveryone,
    DateTime? editedAt,
  }) {
    return ChatMessage(
      id: id,
      text: text ?? this.text,
      time: time ?? this.time,
      isMine: isMine ?? this.isMine,
      status: status ?? this.status,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      voiceDuration: voiceDuration ?? this.voiceDuration,
      senderId: senderId ?? this.senderId,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      reactions: reactions ?? this.reactions,
      isPinned: isPinned ?? this.isPinned,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isStarred: isStarred ?? this.isStarred,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      metadata: metadata ?? this.metadata,
      deletedForMe: deletedForMe ?? this.deletedForMe,
      deletedForEveryone: deletedForEveryone ?? this.deletedForEveryone,
      editedAt: editedAt ?? this.editedAt,
    );
  }

  Map<String, Object?> toCacheMap() {
    return {
      'id': id,
      'text': text,
      'time': time,
      'isMine': isMine,
      'status': status.name,
      'type': type.name,
      'createdAt': createdAt?.toIso8601String(),
      'imageUrl': imageUrl,
      'voiceDuration': voiceDuration?.inMilliseconds,
      'senderId': senderId,
      'replyToMessageId': replyToMessageId,
      'reactions': reactions,
      'isPinned': isPinned,
      'isBookmarked': isBookmarked,
      'isStarred': isStarred,
      'scheduledAt': scheduledAt?.toIso8601String(),
      'deletedForMe': deletedForMe,
      'deletedForEveryone': deletedForEveryone,
      'editedAt': editedAt?.toIso8601String(),
    };
  }
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
    this.ownerId = 'me',
    this.adminIds = const [],
    this.moderatorIds = const [],
    this.announcementMode = false,
    this.inviteCode,
    this.pinnedMessageIds = const [],
  });

  final String name;
  final int members;
  final String topic;
  final String ownerId;
  final List<String> adminIds;
  final List<String> moderatorIds;
  final bool announcementMode;
  final String? inviteCode;
  final List<String> pinnedMessageIds;
}

class OfflineMessageJob {
  const OfflineMessageJob({
    required this.id,
    required this.conversationId,
    required this.message,
    this.retryCount = 0,
  });

  final String id;
  final String conversationId;
  final ChatMessage message;
  final int retryCount;
}

class SearchResult {
  const SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
  });

  final String id;
  final String title;
  final String subtitle;
  final String type;
}
