import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../data/models/chat_message.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../coaches/data/models/coach.dart';

class ChatPage extends StatefulWidget {
  final Coach coach;
  const ChatPage({super.key, required this.coach});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    context.read<ChatCubit>().sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(widget.coach)..init(),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Text(widget.coach.avatarEmoji,
                    style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.coach.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(widget.coach.specialty,
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocConsumer<ChatCubit, ChatState>(
                  listener: (context, state) {
                    _scrollToBottom();
                    if (state is ChatError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Failed to get a response. Please try again.'),
                          backgroundColor: Theme.of(context).colorScheme.error,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    List<ChatMessage> messages = [];
                    bool isTyping = false;
                    bool hasError = false;

                    if (state is ChatLoaded) {
                      messages = state.messages;
                      isTyping = state.isTyping;
                    } else if (state is ChatLoading) {
                      messages = state.messages;
                      isTyping = true;
                    } else if (state is ChatError) {
                      messages = state.messages;
                      hasError = true;
                    } else if (state is ChatInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length + (isTyping ? 1 : 0) + (hasError ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (isTyping && index == messages.length) {
                          return _TypingIndicator(
                              coachEmoji: widget.coach.avatarEmoji);
                        }
                        if (hasError && index == messages.length) {
                          return _ErrorBubble(error: (state as ChatError).message);
                        }
                        return _MessageBubble(message: messages[index]);
                      },
                    );
                  },
                ),
              ),
              _InputBar(
                controller: _controller,
                onSend: () => _sendMessage(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
        ),
        child: message.isUser
            ? Text(
                message.content,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              )
            : MarkdownBody(
                data: message.content,
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(color: Colors.black87, fontSize: 15),
                  strong: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  listBullet: const TextStyle(color: Colors.black87, fontSize: 15),
                ),
              ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  final String coachEmoji;
  const _TypingIndicator({required this.coachEmoji});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text('$coachEmoji is typing...',
            style: const TextStyle(color: Colors.black54, fontSize: 14)),
      ),
    );
  }
}

class _ErrorBubble extends StatelessWidget {
  final String error;
  const _ErrorBubble({required this.error});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                size: 16, color: Theme.of(context).colorScheme.onErrorContainer),
            const SizedBox(width: 6),
            Flexible(
              child: Text(error,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onSubmitted: (_) => onSend(),
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  hintText: 'Ask your coach...',
                  filled: true,
                  fillColor:
                      Theme.of(context).colorScheme.surfaceContainerHigh,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: onSend,
              icon: const Icon(Icons.send),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
