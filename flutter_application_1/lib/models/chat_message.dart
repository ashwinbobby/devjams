
enum ChatMessageType { normal, sos, system }

class ChatMessage {
  final String text;
  final String senderName;
  final String senderId;
  final DateTime timestamp;
  final bool isSystemMessage;
  final ChatMessageType type;

  ChatMessage({
    required this.text,
    required this.senderName,
    required this.senderId,
    required this.timestamp,
    this.isSystemMessage = false,
    this.type = ChatMessageType.normal,
  });

  bool get isSos => type == ChatMessageType.sos;
}
