import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chat_models.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) => ChatRepository());

final chatListProvider = FutureProvider<List<ChatContact>>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 700));
  return ref.watch(chatRepositoryProvider).contacts;
});

final selectedChatProvider = Provider<ChatContact>((ref) {
  return ref.watch(chatRepositoryProvider).contacts.first;
});

final messagesProvider = Provider<List<ChatMessage>>((ref) {
  return ref.watch(chatRepositoryProvider).messages;
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
          isRead: true,
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
          isRead: true,
          type: MessageType.voice,
          voiceDuration: Duration(seconds: 38),
        ),
      ];

  List<CallLog> get calls => const [
        CallLog(name: 'Aanya Sharma', time: 'Today, 10:14', isVideo: true, missed: false),
        CallLog(name: 'Rohan Mehta', time: 'Yesterday, 18:05', isVideo: false, missed: true),
        CallLog(name: 'Design Circle', time: 'Friday, 13:22', isVideo: true, missed: false),
      ];

  List<GroupRoom> get groups => const [
        GroupRoom(name: 'Design Circle', members: 12, topic: 'Brand, UX, launch craft'),
        GroupRoom(name: 'Ops Channel', members: 26, topic: 'Releases and incidents'),
        GroupRoom(name: 'Weekend Plans', members: 7, topic: 'Food, routes, and reminders'),
      ];
}
