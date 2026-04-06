import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/coaches_cubit.dart';
import '../cubit/coaches_state.dart';
import '../data/models/coach.dart';

class CoachesPage extends StatelessWidget {
  const CoachesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Coaches'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<CoachesCubit, CoachesState>(
        builder: (context, state) {
          if (state is CoachesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CoachesError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is CoachesLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.coaches.length,
              itemBuilder: (context, index) {
                final coach = state.coaches[index];
                return _CoachCard(coach: coach);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _CoachCard extends StatelessWidget {
  final Coach coach;
  const _CoachCard({required this.coach});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(coach.avatarEmoji, style: const TextStyle(fontSize: 24)),
        ),
        title: Text(coach.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(coach.specialty,
            style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: Navigate to chat
        },
      ),
    );
  }
}
