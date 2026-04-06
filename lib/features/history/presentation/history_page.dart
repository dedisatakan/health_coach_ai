import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/history_cubit.dart';
import '../cubit/history_state.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

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
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: const Icon(Icons.chat),
                      ),
                      title: Text(session.coachName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        DateFormat('MMM d, yyyy • HH:mm')
                            .format(session.startedAt),
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: Text(
                        '${session.messageIds.length} msgs',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12),
                      ),
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
