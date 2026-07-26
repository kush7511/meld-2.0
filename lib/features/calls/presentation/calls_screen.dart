import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_search_bar.dart';
import '../../../core/widgets/brand_app_bar.dart';
import '../../chat/data/chat_repository.dart';

class CallsScreen extends ConsumerWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calls = ref.watch(callLogsProvider);

    return Scaffold(
      appBar: const BrandAppBar(title: 'Calls'),
      body: calls.isEmpty
          ? const AppEmptyState(
              icon: Icons.call_outlined,
              title: 'No calls yet',
              message: 'Voice and video calls will show up here.',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              children: [
                const AppSearchBar(hint: 'Search calls'),
                const SizedBox(height: 18),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: calls
                        .map(
                          (call) => ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: AppAvatar(name: call.name),
                            title: Text(
                              call.name,
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                            subtitle: Text(
                              call.time,
                              style: TextStyle(
                                color: call.missed ? Colors.redAccent : Colors.black54,
                              ),
                            ),
                            trailing: Icon(
                              call.isVideo ? Icons.videocam_rounded : Icons.call_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
    );
  }
}
