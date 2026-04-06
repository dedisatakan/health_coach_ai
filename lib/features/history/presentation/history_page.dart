import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/services/hive_service.dart';
import '../../../features/coaches/cubit/coaches_cubit.dart';
import '../../../features/coaches/cubit/coaches_state.dart';
import '../../../features/coaches/data/models/coach.dart';
import '../../chat/presentation/chat_page.dart';
import '../cubit/history_cubit.dart';
import '../cubit/history_state.dart';
import '../data/models/chat_session.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  String _lastMessageSnippet(ChatSession session) {
    if (session.messageIds.isEmpty) return 'No messages yet';
    final lastId = session.messageIds.last;
    final message = HiveService.messagesBox.get(lastId);
    if (message == null) return 'No messages yet';
    final content = message.content.replaceAll(RegExp(r'\*+'), '');
    return content.length > 60 ? '${content.substring(0, 60)}...' : content;
  }

  Coach _coachFromSession(BuildContext context, ChatSession session) {
    final coachesState = context.read<CoachesCubit>().state;
    if (coachesState is CoachesLoaded) {
      final match = coachesState.coaches
          .where((c) => c.id == session.coachId)
          .firstOrNull;
      if (match != null) return match;
    }
    const avatars = {
      'dietitian': '🥗',
      'fitness': '💪',
      'pilates': '🧘',
      'yoga': '🪷',
    };
    return Coach(
      id: session.coachId,
      name: session.coachName,
      specialty: '',
      persona: '',
      avatarEmoji: avatars[session.coachId] ?? '🤖',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoaded) {
            if (state.sessions.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No conversations yet',
                        style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.sessions.length,
              itemBuilder: (context, index) {
                final session = state.sessions[index];
                final coach = _coachFromSession(context, session);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: Text(coach.avatarEmoji,
                          style: const TextStyle(fontSize: 20)),
                    ),
                    title: Text(session.coachName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text(
                          DateFormat('MMM d, yyyy • HH:mm')
                              .format(session.startedAt),
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _lastMessageSnippet(session),
                          style: const TextStyle(fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChatPage(
                            coach: coach,
                            existingSession: session,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
