
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
      'isSystemMessage': message.isSystemMessage,
      'type': message.type.toString().split('.').last,
    });
  }

  static ChatMessage decodeMessage(String jsonString) {
    final messageData = jsonDecode(jsonString);
    return ChatMessage(
      text: messageData['text'],
      senderName: messageData['senderName'],
      senderId: messageData['senderId'],
      timestamp: DateTime.parse(messageData['timestamp']),
      isSystemMessage: messageData['isSystemMessage'] ?? false,
      type: _parseType(messageData['type']),
    );
  }

  static ChatMessageType _parseType(dynamic type) {
    if (type == null) return ChatMessageType.normal;
    if (type is ChatMessageType) return type;
    final typeStr = type.toString();
    switch (typeStr) {
      case 'sos':
        return ChatMessageType.sos;
      case 'system':
        return ChatMessageType.system;
      default:
        return ChatMessageType.normal;
    }
  }
}
