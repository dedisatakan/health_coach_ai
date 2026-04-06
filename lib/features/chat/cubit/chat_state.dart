import 'package:equatable/equatable.dart';
import '../data/models/chat_message.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {
  final List<ChatMessage> messages;
  const ChatLoading(this.messages);
  @override
  List<Object?> get props => [messages];
}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;
  const ChatLoaded({required this.messages, this.isTyping = false});
  @override
  List<Object?> get props => [messages, isTyping];
}

class ChatError extends ChatState {
  final String message;
  final List<ChatMessage> messages;
  const ChatError({required this.message, required this.messages});
  @override
  List<Object?> get props => [message, messages];
}
