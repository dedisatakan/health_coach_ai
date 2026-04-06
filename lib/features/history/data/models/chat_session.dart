import 'package:hive_flutter/hive_flutter.dart';

part 'chat_session.g.dart';

@HiveType(typeId: 0)
class ChatSession extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String coachId;

  @HiveField(2)
  final String coachName;

  @HiveField(3)
  final DateTime startedAt;

  @HiveField(4)
  late List<String> messageIds;

  ChatSession({
    required this.id,
    required this.coachId,
    required this.coachName,
    required this.startedAt,
    List<String>? messageIds,
  }) : messageIds = messageIds ?? [];
}
