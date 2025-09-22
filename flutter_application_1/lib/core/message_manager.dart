
import 'dart:convert';
import '../models/chat_message.dart';

// This class will encapsulate all message management logic for modularity.
// For now, it will be a placeholder with static methods to be filled in next.
class MessageManager {
  static String encodeMessage(ChatMessage message) {
    return jsonEncode({
      'text': message.text,
      'senderName': message.senderName,
      'senderId': message.senderId,
      'timestamp': message.timestamp.toIso8601String(),
    });
  }

  static ChatMessage decodeMessage(String jsonString) {
    final messageData = jsonDecode(jsonString);
    return ChatMessage(
      text: messageData['text'],
      senderName: messageData['senderName'],
      senderId: messageData['senderId'],
      timestamp: DateTime.parse(messageData['timestamp']),
    );
  }
}
