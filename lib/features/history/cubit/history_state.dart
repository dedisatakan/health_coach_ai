import 'package:equatable/equatable.dart';
import '../data/models/chat_session.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<ChatSession> sessions;
  const HistoryLoaded(this.sessions);
  @override
  List<Object?> get props => [sessions];
}
