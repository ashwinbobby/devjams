class ChatMessage {
  final String text;
  final String senderName;
  final String senderId;
  final DateTime timestamp;
  final bool isSystemMessage;

  ChatMessage({
    required this.text,
    required this.senderName,
    required this.senderId,
    required this.timestamp,
    this.isSystemMessage = false,
  });
}
