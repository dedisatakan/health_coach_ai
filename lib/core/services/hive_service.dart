import 'package:hive_flutter/hive_flutter.dart';
import '../../features/chat/data/models/chat_message.dart';
import '../../features/history/data/models/chat_session.dart';

class HiveService {
  static const String _sessionsBox = 'chat_sessions';
  static const String _messagesBox = 'chat_messages';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ChatSessionAdapter());
    Hive.registerAdapter(ChatMessageAdapter());
    await Hive.openBox<ChatSession>(_sessionsBox);
    await Hive.openBox<ChatMessage>(_messagesBox);
  }

  static Box<ChatSession> get sessionsBox => Hive.box<ChatSession>(_sessionsBox);
  static Box<ChatMessage> get messagesBox => Hive.box<ChatMessage>(_messagesBox);
}
