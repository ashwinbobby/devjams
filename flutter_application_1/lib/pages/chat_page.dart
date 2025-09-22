import 'package:flutter/material.dart';
import '../main.dart';
import '../models/chat_message.dart';

class ChatPage extends StatelessWidget {
  final AppState state;
  final UserRole userRole;
  final List<ChatMessage> messages;
  final TextEditingController messageController;
  final VoidCallback onSendMessage;
  final VoidCallback? onStartChatting;
  final String currentUserId;
  final String currentUserName;
  final Map<String, String> connectedClients;
  final String? hostEndpointId;
  final Function(String, String) sendPayload;

  const ChatPage({
    Key? key,
    required this.state,
    required this.userRole,
    required this.messages,
    required this.messageController,
    required this.onSendMessage,
    required this.currentUserId,
    required this.currentUserName,
    required this.connectedClients,
    required this.hostEndpointId,
    required this.sendPayload,
    this.onStartChatting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state == AppState.connected) {
      return Column(
        children: [
          Expanded(child: _buildChatView(context)),
          _buildMessageInput(context),
        ],
      );
    } else if (userRole == UserRole.host && connectedClients.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Clients connected. Start chat!'),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: onStartChatting,
                child: const Text('Start Chatting'),
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Text(
          'Connect to a host to start chatting.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }
  }

  Widget _buildChatView(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: messages.isEmpty
              ? const Center(
                  child: Text(
                    'No messages yet.\nStart the conversation!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    return _buildMessageBubble(context, message);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage message) {
    final isOwnMessage = message.senderId == currentUserId;
    final isSystemMessage = message.isSystemMessage;

    if (isSystemMessage) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message.text,
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Align(
        alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isOwnMessage ? Colors.blue[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isOwnMessage) ...[
                Text(
                  message.senderName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
              ],
              Text(
                message.text,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                _formatTime(message.timestamp),
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              onSubmitted: (_) => onSendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: onSendMessage,
            mini: true,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
