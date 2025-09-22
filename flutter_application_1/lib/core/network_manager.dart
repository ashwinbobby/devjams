import 'package:nearby_connections/nearby_connections.dart';
import 'dart:typed_data';
import '../models/chat_message.dart';

// This class will encapsulate all Nearby/network logic for modularity.
// For now, it will be a placeholder with static methods to be filled in next.
typedef ConnectionInitiatedCallback = void Function(String endpointId, ConnectionInfo info);
typedef ConnectionResultCallback = void Function(String endpointId, Status status);
typedef DisconnectedCallback = void Function(String endpointId);
typedef EndpointFoundCallback = void Function(String endpointId, String endpointName, String serviceId);
typedef EndpointLostCallback = void Function(String? endpointId);
typedef PayloadReceivedCallback = void Function(String endpointId, Payload payload);

class NetworkManager {
  static const String SERVICE_ID = "com.hostclient.messaging";
  static const Strategy STRATEGY = Strategy.P2P_STAR;

  static Future<bool> startAdvertising(
    String userName,
    ConnectionInitiatedCallback onConnectionInitiated,
    ConnectionResultCallback onConnectionResult,
    DisconnectedCallback onDisconnected,
    PayloadReceivedCallback onPayloadReceived,
  ) async {
    return await Nearby().startAdvertising(
      userName,
      STRATEGY,
      onConnectionInitiated: onConnectionInitiated,
      onConnectionResult: onConnectionResult,
      onDisconnected: onDisconnected,
      serviceId: SERVICE_ID,
    );
  }

  static Future<bool> startDiscovery(
    String userName,
    EndpointFoundCallback onEndpointFound,
    EndpointLostCallback onEndpointLost,
  ) async {
    return await Nearby().startDiscovery(
      userName,
      STRATEGY,
      onEndpointFound: onEndpointFound,
      onEndpointLost: (endpointId) => onEndpointLost(endpointId),
      serviceId: SERVICE_ID,
    );
  }

  static Future<bool> requestConnection(
    String userName,
    String endpointId,
    ConnectionInitiatedCallback onConnectionInitiated,
    ConnectionResultCallback onConnectionResult,
    DisconnectedCallback onDisconnected,
  ) async {
    return await Nearby().requestConnection(
      userName,
      endpointId,
      onConnectionInitiated: onConnectionInitiated,
      onConnectionResult: onConnectionResult,
      onDisconnected: onDisconnected,
    );
  }

  static Future<void> acceptConnection(
    String endpointId,
    PayloadReceivedCallback onPayloadReceived,
  ) async {
    await Nearby().acceptConnection(
      endpointId,
      onPayLoadRecieved: onPayloadReceived,
    );
  }

  static Future<void> rejectConnection(String endpointId) async {
    await Nearby().rejectConnection(endpointId);
  }

  static Future<void> sendBytesPayload(String endpointId, Uint8List bytes) async {
    await Nearby().sendBytesPayload(endpointId, bytes);
  }

  static Future<void> stopAdvertising() async {
    await Nearby().stopAdvertising();
  }

  static Future<void> stopDiscovery() async {
    await Nearby().stopDiscovery();
  }

  static Future<void> stopAllEndpoints() async {
    await Nearby().stopAllEndpoints();
  }
}
