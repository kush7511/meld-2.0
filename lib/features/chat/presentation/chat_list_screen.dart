import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_search_bar.dart';
import '../../../core/widgets/brand_app_bar.dart';
import '../../../core/widgets/feedback_surfaces.dart';
import '../data/chat_repository.dart';
import 'chat_screen.dart';
import 'chat_tile.dart';
import 'story_row.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatListProvider);

    return Scaffold(
      appBar: BrandAppBar(
        title: 'LeafChat',
        actions: [
          IconButton(
            tooltip: 'Filters',
            onPressed: () => showAppBottomSheet<void>(
              context: context,
              child: const _FilterSheet(),
            ),
            icon: const Icon(Icons.tune_rounded),
          ),
          IconButton(
            tooltip: 'More',
            onPressed: () => showAppDialog(
              context: context,
              title: 'All caught up',
              message: 'Your chats are synced and ready.',
            ),
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: chats.when(
        loading: () => const _ChatSkeleton(),
        error: (error, stackTrace) => AppErrorState(
          message: 'Could not load conversations.',
          onRetry: () => ref.invalidate(chatListProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const AppEmptyState(
              icon: Icons.forum_outlined,
              title: 'No conversations yet',
              message: 'Start a new chat and your recent conversations will appear here.',
            );
          }

          final pinned = items.where((chat) => chat.isPinned).toList();

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                sliver: SliverToBoxAdapter(
                  child: AppSearchBar(hint: 'Search messages, people, groups'),
                ),
              ),
              SliverToBoxAdapter(child: StoryRow(contacts: items)),
              if (pinned.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Pinned chats',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                ),
              if (pinned.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: AppCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: pinned
                            .map(
                              (chat) => ChatTile(
                                chat: chat,
                                onTap: () => Navigator.pushNamed(context, ChatScreen.routeName),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Recent',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverToBoxAdapter(
                  child: AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: items
                          .map(
                            (chat) => ChatTile(
                              chat: chat,
                              onTap: () => Navigator.pushNamed(context, ChatScreen.routeName),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FilterSheet extends StatelessWidget {
  const _FilterSheet();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.mark_chat_unread_rounded),
          title: const Text('Unread only'),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: const Icon(Icons.push_pin_rounded),
          title: const Text('Pinned first'),
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class _ChatSkeleton extends StatelessWidget {
  const _ChatSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 7,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return AppCard(
          child: Row(
            children: [
              const CircleAvatar(radius: 25, backgroundColor: Color(0xFFE8F1EA)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FractionallySizedBox(
                      widthFactor: .55,
                      child: Container(height: 12, decoration: _skeletonDecoration()),
                    ),
                    const SizedBox(height: 10),
                    FractionallySizedBox(
                      widthFactor: .85,
                      child: Container(height: 10, decoration: _skeletonDecoration()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  BoxDecoration _skeletonDecoration() {
    return BoxDecoration(
      color: const Color(0xFFE8F1EA),
      borderRadius: BorderRadius.circular(20),
    );
  }
}
