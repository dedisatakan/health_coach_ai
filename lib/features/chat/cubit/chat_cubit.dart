import 'package:firebase_ai/firebase_ai.dart' as ai;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/hive_service.dart';
import '../../../features/coaches/data/models/coach.dart';
import '../data/models/chat_message.dart';
import '../../history/data/models/chat_session.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final Coach coach;
  late final ai.GenerativeModel _model;
  late final ChatSession _session;
  late final Box<ChatMessage> _messagesBox;
  late final Box<ChatSession> _sessionsBox;
  final _uuid = const Uuid();
  late ai.ChatSession _chat;

  ChatCubit(this.coach) : super(ChatInitial());

  Future<void> init() async {
    _messagesBox = HiveService.messagesBox;
    _sessionsBox = HiveService.sessionsBox;

    _model = ai.FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.0-flash',
      systemInstruction: ai.Content.system(coach.persona),
    );

    _session = ChatSession(
      id: _uuid.v4(),
      coachId: coach.id,
      coachName: coach.name,
      startedAt: DateTime.now(),
    );
    await _sessionsBox.put(_session.id, _session);

    _chat = _model.startChat();
    emit(ChatLoaded(messages: const []));
  }

  Future<void> sendMessage(String text) async {
    final currentMessages = _getCurrentMessages();

    final userMessage = ChatMessage(
      id: _uuid.v4(),
      content: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    await _messagesBox.put(userMessage.id, userMessage);
    _session.messageIds.add(userMessage.id);
    await _session.save();

    final updatedMessages = [...currentMessages, userMessage];
    emit(ChatLoaded(messages: updatedMessages, isTyping: true));

    try {
      final response = await _chat.sendMessage(ai.Content.text(text));
      final responseText = response.text ?? 'Sorry, I could not respond.';

      final aiMessage = ChatMessage(
        id: _uuid.v4(),
        content: responseText,
        isUser: false,
        timestamp: DateTime.now(),
      );
      await _messagesBox.put(aiMessage.id, aiMessage);
      _session.messageIds.add(aiMessage.id);
      await _session.save();

      emit(ChatLoaded(messages: [...updatedMessages, aiMessage]));
    } catch (e) {
      emit(ChatError(message: e.toString(), messages: updatedMessages));
    }
  }

  List<ChatMessage> _getCurrentMessages() {
    if (state is ChatLoaded) return (state as ChatLoaded).messages;
    if (state is ChatLoading) return (state as ChatLoading).messages;
    if (state is ChatError) return (state as ChatError).messages;
    return [];
  }
}
