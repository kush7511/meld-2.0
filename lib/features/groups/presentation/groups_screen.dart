import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_search_bar.dart';
import '../../../core/widgets/brand_app_bar.dart';
import '../../chat/data/chat_repository.dart';

class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(groupsProvider);

    return Scaffold(
      appBar: const BrandAppBar(title: 'Groups'),
      body: groups.isEmpty
          ? const AppEmptyState(
              icon: Icons.groups_outlined,
              title: 'No groups yet',
              message: 'Create a group for teams, family, or shared plans.',
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const AppSearchBar(hint: 'Search groups');
                }
                final group = groups[index - 1];
                return AppCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        child: Icon(
                          Icons.groups_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${group.members} members - ${group.topic}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Open group',
                        onPressed: () {},
                        icon: const Icon(Icons.chevron_right_rounded),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: groups.length + 1,
            ),
    );
  }
}
