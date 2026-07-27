import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chat_models.dart';

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepository(),
);

final chatListProvider = FutureProvider<List<ChatContact>>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 700));
  return ref.watch(conversationControllerProvider);
});

final selectedChatProvider = Provider<ChatContact>((ref) {
  return ref.watch(conversationControllerProvider).first;
});

final messagesProvider = Provider<List<ChatMessage>>((ref) {
  return ref.watch(messageControllerProvider);
});

final conversationControllerProvider =
    StateNotifierProvider<ConversationController, List<ChatContact>>((ref) {
  return ConversationController(ref.watch(chatRepositoryProvider));
});

final messageControllerProvider =
    StateNotifierProvider<MessageController, List<ChatMessage>>((ref) {
  return MessageController(ref.watch(chatRepositoryProvider));
});

final globalSearchProvider =
    Provider.family<List<SearchResult>, String>((ref, query) {
  return ref.watch(chatRepositoryProvider).search(
        query: query,
        contacts: ref.watch(conversationControllerProvider),
        messages: ref.watch(messageControllerProvider),
      );
});

final callLogsProvider = Provider<List<CallLog>>((ref) {
  return ref.watch(chatRepositoryProvider).calls;
});

final groupsProvider = Provider<List<GroupRoom>>((ref) {
  return ref.watch(chatRepositoryProvider).groups;
});

class ChatRepository {
  List<ChatContact> get contacts => const [
    ChatContact(
      id: '1',
      name: 'Aanya Sharma',
      handle: '@aanya',
      lastMessage: 'Voice note from the launch standup',
      time: '09:42',
      unreadCount: 2,
      isOnline: true,
      isPinned: true,
      isTyping: true,
    ),
    ChatContact(
      id: '2',
      name: 'Design Circle',
      handle: '12 members',
      lastMessage: 'Mira shared a concept board',
      time: '08:15',
      unreadCount: 0,
      isOnline: false,
      isPinned: true,
      isTyping: false,
    ),
    ChatContact(
      id: '3',
      name: 'Rohan Mehta',
      handle: '@rohan',
      lastMessage: 'Let us review the production checklist.',
      time: 'Yesterday',
      unreadCount: 0,
      isOnline: true,
      isPinned: false,
      isTyping: false,
    ),
    ChatContact(
      id: '4',
      name: 'Ops Channel',
      handle: '26 members',
      lastMessage: 'Incident notes are ready.',
      time: 'Sat',
      unreadCount: 6,
      isOnline: false,
      isPinned: false,
      isTyping: false,
    ),
  ];

  List<ChatMessage> get messages => const [
    ChatMessage(
      id: 'm1',
      text: 'Can you check the final onboarding copy?',
      time: '09:20',
      isMine: false,
      type: MessageType.text,
    ),
    ChatMessage(
      id: 'm2',
      text: 'Yes. I tightened the empty states and settings labels.',
      time: '09:24',
      isMine: true,
      status: MessageDeliveryStatus.read,
      type: MessageType.text,
    ),
    ChatMessage(
      id: 'm3',
      text: 'Product preview',
      time: '09:31',
      isMine: false,
      type: MessageType.image,
      imageUrl:
          'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=900',
    ),
    ChatMessage(
      id: 'm4',
      text: 'Audio note',
      time: '09:36',
      isMine: true,
      status: MessageDeliveryStatus.read,
      type: MessageType.voiceNote,
      voiceDuration: Duration(seconds: 38),
    ),
  ];

  List<CallLog> get calls => const [
    CallLog(
      name: 'Aanya Sharma',
      time: 'Today, 10:14',
      isVideo: true,
      missed: false,
    ),
    CallLog(
      name: 'Rohan Mehta',
      time: 'Yesterday, 18:05',
      isVideo: false,
      missed: true,
    ),
    CallLog(
      name: 'Design Circle',
      time: 'Friday, 13:22',
      isVideo: true,
      missed: false,
    ),
  ];

  List<GroupRoom> get groups => const [
    GroupRoom(
      name: 'Design Circle',
      members: 12,
      topic: 'Brand, UX, launch craft',
    ),
    GroupRoom(
      name: 'Ops Channel',
      members: 26,
      topic: 'Releases and incidents',
    ),
    GroupRoom(
      name: 'Weekend Plans',
      members: 7,
      topic: 'Food, routes, and reminders',
    ),
  ];

  List<SearchResult> search({
    required String query,
    required List<ChatContact> contacts,
    required List<ChatMessage> messages,
  }) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return const [];

    final contactResults = contacts
        .where(
          (contact) =>
              contact.name.toLowerCase().contains(normalized) ||
              contact.handle.toLowerCase().contains(normalized) ||
              contact.lastMessage.toLowerCase().contains(normalized),
        )
        .map(
          (contact) => SearchResult(
            id: contact.id,
            title: contact.name,
            subtitle: contact.lastMessage,
            type: 'conversation',
          ),
        );

    final messageResults = messages
        .where((message) => message.text.toLowerCase().contains(normalized))
        .map(
          (message) => SearchResult(
            id: message.id,
            title: message.text,
            subtitle: message.time,
            type: message.type.name,
          ),
        );

    return [...contactResults, ...messageResults];
  }
}

class ConversationController extends StateNotifier<List<ChatContact>> {
  ConversationController(ChatRepository repository) : super(repository.contacts);

  void togglePinned(String conversationId) {
    state = [
      for (final contact in state)
        if (contact.id == conversationId)
          contact.copyWith(isPinned: !contact.isPinned)
        else
          contact,
    ];
  }

  void toggleArchived(String conversationId) {
    state = [
      for (final contact in state)
        if (contact.id == conversationId)
          contact.copyWith(
            isArchived: !contact.isArchived,
            folder: contact.isArchived
                ? ConversationFolder.inbox
                : ConversationFolder.archived,
          )
        else
          contact,
    ];
  }

  void toggleMuted(String conversationId) {
    state = [
      for (final contact in state)
        if (contact.id == conversationId)
          contact.copyWith(isMuted: !contact.isMuted)
        else
          contact,
    ];
  }

  void updateTyping(String conversationId, bool isTyping) {
    state = [
      for (final contact in state)
        if (contact.id == conversationId)
          contact.copyWith(isTyping: isTyping, lastActive: DateTime.now())
        else
          contact,
    ];
  }
}

class MessageController extends StateNotifier<List<ChatMessage>> {
  MessageController(ChatRepository repository) : super(repository.messages);

  void sendText(String text, {DateTime? scheduledAt, String? replyToMessageId}) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final now = DateTime.now();
    final message = ChatMessage(
      id: 'local-${now.microsecondsSinceEpoch}',
      text: trimmed,
      time:
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      isMine: true,
      type: MessageType.text,
      status: scheduledAt == null
          ? MessageDeliveryStatus.sending
          : MessageDeliveryStatus.sent,
      createdAt: now,
      scheduledAt: scheduledAt,
      replyToMessageId: replyToMessageId,
    );

    state = [...state, message];

    if (scheduledAt == null) {
      Future<void>.delayed(const Duration(milliseconds: 350), () {
        _updateStatus(message.id, MessageDeliveryStatus.sent);
      });
      Future<void>.delayed(const Duration(milliseconds: 900), () {
        _updateStatus(message.id, MessageDeliveryStatus.delivered);
      });
    }
  }

  void editMessage(String messageId, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    state = [
      for (final message in state)
        if (message.id == messageId && message.isMine)
          message.copyWith(text: trimmed, editedAt: DateTime.now())
        else
          message,
    ];
  }

  void deleteForMe(String messageId) {
    state = [
      for (final message in state)
        if (message.id == messageId)
          message.copyWith(deletedForMe: true)
        else
          message,
    ];
  }

  void deleteForEveryone(String messageId) {
    state = [
      for (final message in state)
        if (message.id == messageId && message.isMine)
          message.copyWith(
            text: 'This message was deleted',
            deletedForEveryone: true,
            imageUrl: '',
          )
        else
          message,
    ];
  }

  void react(String messageId, String emoji) {
    state = [
      for (final message in state)
        if (message.id == messageId)
          message.copyWith(reactions: {...message.reactions, 'me': emoji})
        else
          message,
    ];
  }

  void togglePinned(String messageId) => _toggleFlag(
        messageId,
        (message) => message.copyWith(isPinned: !message.isPinned),
      );

  void toggleBookmark(String messageId) => _toggleFlag(
        messageId,
        (message) => message.copyWith(isBookmarked: !message.isBookmarked),
      );

  void toggleStar(String messageId) => _toggleFlag(
        messageId,
        (message) => message.copyWith(isStarred: !message.isStarred),
      );

  void _toggleFlag(String messageId, ChatMessage Function(ChatMessage) update) {
    state = [
      for (final message in state)
        if (message.id == messageId) update(message) else message,
    ];
  }

  void _updateStatus(String messageId, MessageDeliveryStatus status) {
    if (!mounted) return;
    state = [
      for (final message in state)
        if (message.id == messageId) message.copyWith(status: status) else message,
    ];
  }
}
