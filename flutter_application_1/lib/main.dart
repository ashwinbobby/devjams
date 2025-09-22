
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';
import 'models/chat_message.dart';
import 'core/network_manager.dart';
import 'core/message_manager.dart';
import 'pages/home_page.dart';
import 'pages/sos_page.dart';
import 'pages/chat_page.dart';
// import 'package:device_info_plus/device_info_plus.dart'; // Unused import removed

import 'package:intl/intl.dart';

class _SosPrompt extends StatelessWidget {
  final String senderName;
  final DateTime timestamp;
  final VoidCallback onClose;
  const _SosPrompt({required this.senderName, required this.timestamp, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final String formattedTime = DateFormat('HH:mm:ss - dd/MM/yyyy').format(timestamp);
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 270,
            height: 270,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.5),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 28, 18, 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_rounded, color: Colors.redAccent, size: 60),
                  const SizedBox(height: 2),
                  Text(
                    'SOS',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      fontFamily: 'OrelegaOne',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'from',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    senderName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OrelegaOne',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 18,
            right: 18,
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> main() async {
  runApp(const App());
}

enum AppState { idle, hosting, discovering, connected }
enum UserRole { none, host, client }

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Minimalist dark theme colors
    final Color primaryColor = const Color(0xFF23272F); // Deep blue-grey
    final Color accentColor = const Color(0xFF7F8CFF); // Soft blue accent
    final Color backgroundColor = const Color(0xFF181A20); // Almost black
    final Color cardColor = const Color(0xFF23272F); // Same as primary for minimalism
    final Color textColor = const Color(0xFFEAEAEA); // Subtle off-white
    final Color secondaryTextColor = const Color(0xFFB0B3B8); // Muted grey
    final Color borderColor = const Color(0xFF31343B); // Subtle border

    return MaterialApp(
      title: 'Host-Client Messaging',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        cardColor: cardColor,
        colorScheme: ColorScheme.dark(
          primary: primaryColor,
          secondary: accentColor,
          background: backgroundColor,
        ),
        fontFamily: 'OrelegaOne',
        textTheme: ThemeData.dark().textTheme.copyWith(
          headlineLarge: TextStyle(
            fontFamily: 'OrelegaOne',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'OrelegaOne',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          titleLarge: TextStyle(
            fontFamily: 'OrelegaOne',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'OrelegaOne',
            fontSize: 16,
            color: textColor,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'OrelegaOne',
            fontSize: 14,
            color: secondaryTextColor,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: primaryColor,
            textStyle: const TextStyle(
              fontFamily: 'OrelegaOne',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: borderColor, width: 1),
            ),
            elevation: 0,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: accentColor, width: 2),
          ),
          hintStyle: TextStyle(color: secondaryTextColor),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'OrelegaOne',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          iconTheme: IconThemeData(color: accentColor),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: accentColor,
          foregroundColor: primaryColor,
          elevation: 0,
        ),
        dividerColor: borderColor,
        iconTheme: IconThemeData(color: accentColor),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Host-Client Messaging'),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(20),
          child: const AppBody(),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppBody extends StatefulWidget {
  const AppBody({super.key});

  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  AppState _state = AppState.idle;
  UserRole _userRole = UserRole.none;
  
  // Create our own user ID
  late final String _currentUserId;
  late final String _currentUserName;

  // Device management
  Map<String, String> _connectedClients = {}; // endpointId -> deviceName
  String? _hostEndpointId;

  // Messages
  List<ChatMessage> _messages = [];
  final TextEditingController _messageController = TextEditingController();

  // SOS prompt state
  ChatMessage? _activeSosMessage;
  Timer? _sosTimer;

  void _sendSosMessage() {
    final message = ChatMessage(
      text: 'SOS!',
      senderName: _currentUserName,
      senderId: _currentUserId,
      timestamp: DateTime.now(),
      type: ChatMessageType.sos,
    );
    final messageJson = MessageManager.encodeMessage(message);
    // Show locally
    _showSosPrompt(message);
    // Broadcast
    if (_userRole == UserRole.client && _hostEndpointId != null) {
      _sendPayload(_hostEndpointId!, messageJson);
    } else if (_userRole == UserRole.host) {
      for (String clientEndpointId in _connectedClients.keys) {
        _sendPayload(clientEndpointId, messageJson);
      }
    }
  }

  void _showSosPrompt(ChatMessage sosMessage) {
    _sosTimer?.cancel();
    setState(() {
      _activeSosMessage = sosMessage;
    });
    _sosTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _activeSosMessage = null;
        });
      }
    });
  }

  void _closeSosPrompt() {
    _sosTimer?.cancel();
    setState(() {
      _activeSosMessage = null;
    });
  }

  // Navigation
  int _selectedIndex = 0; // 0: Home, 1: SOS, 2: Chat

  // NetworkManager constants are now used

  @override
  void initState() {
    // Generate unique user ID and name
    _currentUserId = 'user_${DateTime.now().millisecondsSinceEpoch}_${(Platform.isAndroid ? 'android' : 'ios')}';
    _currentUserName = 'User${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _stopAll();
    _messageController.dispose();
    super.dispose();
  }

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show only role selection if idle
    if (_state == AppState.idle) {
      return _buildRoleSelection();
    }

    Widget mainContent = Column(
      children: [
        _buildStatusHeader(),
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              HomePage(
                state: _state,
                userRole: _userRole,
                connectedClients: _connectedClients,
              ),
              SosPage(onSendSos: _sendSosMessage),
              ChatPage(
                state: _state,
                userRole: _userRole,
                messages: _messages,
                messageController: _messageController,
                onSendMessage: _sendMessage,
                currentUserId: _currentUserId,
                currentUserName: _currentUserName,
                connectedClients: _connectedClients,
                hostEndpointId: _hostEndpointId,
                sendPayload: _sendPayload,
                onStartChatting: () => setState(() => _state = AppState.connected),
              ),
            ],
          ),
        ),
        _buildBottomNavBar(),
      ],
    );

    // Overlay SOS prompt if active
    if (_activeSosMessage != null) {
      mainContent = Stack(
        children: [
          // Dimmed background
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.65),
            ),
          ),
          // Centered SOS prompt
          Center(
            child: _SosPrompt(
              senderName: _activeSosMessage!.senderName,
              timestamp: _activeSosMessage!.timestamp,
              onClose: _closeSosPrompt,
            ),
          ),
        ],
      );
    }
    return mainContent;
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home_rounded, color: _selectedIndex == 0 ? Theme.of(context).colorScheme.secondary : Theme.of(context).iconTheme.color, size: 30),
              onPressed: () => _onNavBarTap(0),
              tooltip: 'Home',
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _selectedIndex == 1 ? Colors.redAccent : Theme.of(context).colorScheme.secondary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(_selectedIndex == 1 ? 0.3 : 0.1),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.warning_rounded, color: Colors.white, size: 32),
                onPressed: () => _onNavBarTap(1),
                tooltip: 'SOS',
              ),
            ),
            IconButton(
              icon: Icon(Icons.chat_bubble_rounded, color: _selectedIndex == 2 ? Theme.of(context).colorScheme.secondary : Theme.of(context).iconTheme.color, size: 30),
              onPressed: () => _onNavBarTap(2),
              tooltip: 'Chat',
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildStatusHeader() {
    String statusText;
    Color statusColor;

    switch (_state) {
      case AppState.idle:
        statusText = 'Not Connected';
        statusColor = Colors.grey;
        break;
      case AppState.hosting:
        statusText = 'HOST - ${_connectedClients.length} clients connected';
        statusColor = Colors.green;
        break;
      case AppState.discovering:
        statusText = 'Searching for host...';
        statusColor = Colors.orange;
        break;
      case AppState.connected:
        statusText = _userRole == UserRole.host 
            ? 'HOST - ${_connectedClients.length} clients connected'
            : 'CLIENT - Connected to host';
        statusColor = Colors.green;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        border: Border.all(color: statusColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                if (_userRole == UserRole.host && _connectedClients.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Connected: ${_connectedClients.values.join(', ')}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
          if (_state != AppState.idle)
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.logout, color: Colors.redAccent, size: 26),
                tooltip: 'Disconnect',
                onPressed: _stopAndGoBack,
                splashRadius: 22,
                padding: const EdgeInsets.all(4),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.redAccent.withOpacity(0.1)),
                ),
              ),
            ),
        ],
      ),
    );
  }



  Widget _buildRoleSelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Choose your role:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _startAsHost,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Create Host', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _startAsClient,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Join as Client', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'No WiFi or internet needed!\nDevices communicate directly using Bluetooth/WiFi Direct.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }








  Future<void> _initialize() async {
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
      Permission.nearbyWifiDevices,
    ].request();

    bool allGranted = statuses.values.every((status) => 
        status == PermissionStatus.granted || status == PermissionStatus.limited);
    
    if (!allGranted) {
      _showError('Please grant all permissions for the app to work');
    }
  }

  Future<void> _startAsHost() async {
    setState(() {
      _userRole = UserRole.host;
      _state = AppState.hosting;
    });

    _addSystemMessage('Starting host...');

    try {
      bool result = await NetworkManager.startAdvertising(
        _currentUserName,
        _onConnectionInitiated,
        _onConnectionResult,
        _onDisconnected,
        _onPayloadReceived,
      );
      if (result) {
        _addSystemMessage('Host started successfully!');
        _addSystemMessage('Waiting for clients to connect...');
      } else {
        throw Exception('Failed to start advertising');
      }
    } catch (e) {
      _showError('Failed to start host: $e');
      _stopAndGoBack();
    }
  }

  Future<void> _startAsClient() async {
    setState(() {
      _userRole = UserRole.client;
      _state = AppState.discovering;
    });

    try {
      bool result = await NetworkManager.startDiscovery(
        _currentUserName,
        _onEndpointFound,
        (endpointId) {
          if (endpointId != null) {
            _onEndpointLost(endpointId);
          }
        },
      );
      if (result) {
        _addSystemMessage('Searching for hosts...');
      } else {
        throw Exception('Failed to start discovery');
      }
    } catch (e) {
      _showError('Failed to start discovery: $e');
      _stopAndGoBack();
    }
  }

  void _onConnectionInitiated(String endpointId, ConnectionInfo info) {
    print('Connection initiated from ${info.endpointName}');
    
    // Auto-accept all connections if we're the host
    if (_userRole == UserRole.host) {
      NetworkManager.acceptConnection(
        endpointId,
        _onPayloadReceived,
      );
    } else {
      // Show dialog for client connections
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text('Connection Request'),
          content: Text('${info.endpointName} wants to connect. Accept?'),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
                Nearby().rejectConnection(endpointId);
              },
              child: const Text('Reject'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).primaryColor,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(context);
                Nearby().acceptConnection(
                  endpointId,
                  onPayLoadRecieved: _onPayloadReceived,
                );
              },
              child: const Text('Accept'),
            ),
          ],
        ),
      );
    }
  }

  void _onConnectionResult(String endpointId, Status status) {
    print('Connection result with $endpointId: ${status.toString()}');
    
    if (status == Status.CONNECTED) {
      if (_userRole == UserRole.host) {
        // Host accepted a client
        setState(() {
          _connectedClients[endpointId] = 'Client_${endpointId.substring(0, 4)}';
          if (_connectedClients.length == 1) {
            _state = AppState.hosting; // Stay in hosting mode until manually switched
          }
        });
        _addSystemMessage('Client connected: ${_connectedClients[endpointId]}');
      } else {
        // Client connected to host
        _hostEndpointId = endpointId;
        setState(() => _state = AppState.connected);
        _addSystemMessage('Connected to host successfully!');
      }
    } else {
      _showError('Connection failed');
    }
  }

  void _onDisconnected(String endpointId) {
    print('Disconnected from $endpointId');
    
    if (_userRole == UserRole.host) {
      final clientName = _connectedClients[endpointId];
      setState(() {
        _connectedClients.remove(endpointId);
        if (_connectedClients.isEmpty && _state == AppState.connected) {
          _state = AppState.hosting;
        }
      });
      if (clientName != null) {
        _addSystemMessage('$clientName disconnected');
      }
    } else {
      _addSystemMessage('Disconnected from host');
      _stopAndGoBack();
    }
  }

  void _onEndpointFound(String endpointId, String endpointName, String serviceId) {
    print('Found endpoint: $endpointName ($endpointId)');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Host Found'),
        content: Text('Found host "$endpointName". Connect?'),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.redAccent,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).primaryColor,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              _requestConnection(endpointId, endpointName);
            },
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  void _onEndpointLost(String endpointId) {
    print('Lost endpoint: $endpointId');
  }

  Future<void> _requestConnection(String endpointId, String endpointName) async {
    try {
      bool result = await NetworkManager.requestConnection(
        _currentUserName,
        endpointId,
        _onConnectionInitiated,
        _onConnectionResult,
        _onDisconnected,
      );
      if (!result) {
        _showError('Failed to request connection');
      }
    } catch (e) {
      _showError('Error requesting connection: $e');
    }
  }

  void _onPayloadReceived(String endpointId, Payload payload) {
    if (payload.type == PayloadType.BYTES) {
      try {
        String jsonString = String.fromCharCodes(payload.bytes!);
        final chatMessage = MessageManager.decodeMessage(jsonString);
        if (chatMessage.isSos) {
          _showSosPrompt(chatMessage);
        }
        setState(() {
          _messages.add(chatMessage);
        });
        // If this is the host, forward the message to all other clients
        if (_userRole == UserRole.host && chatMessage.senderId != _currentUserId) {
          _forwardMessageToOtherClients(jsonString, endpointId);
        }
      } catch (e) {
        print('Error handling received message: $e');
      }
    }
  }

  void _forwardMessageToOtherClients(String messageJson, String originalSenderEndpointId) {
    for (String clientEndpointId in _connectedClients.keys) {
      if (clientEndpointId != originalSenderEndpointId) {
        _sendPayload(clientEndpointId, messageJson);
      }
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final message = ChatMessage(
      text: text,
      senderName: _currentUserName,
      senderId: _currentUserId,
      timestamp: DateTime.now(),
    );
    setState(() {
      _messages.add(message);
    });
    _messageController.clear();
    final messageJson = MessageManager.encodeMessage(message);
    if (_userRole == UserRole.client && _hostEndpointId != null) {
      // Client sends to host
      _sendPayload(_hostEndpointId!, messageJson);
    } else if (_userRole == UserRole.host) {
      // Host sends to all clients
      for (String clientEndpointId in _connectedClients.keys) {
        _sendPayload(clientEndpointId, messageJson);
      }
    }
  }

  void _sendPayload(String endpointId, String messageJson) {
    try {
      NetworkManager.sendBytesPayload(
        endpointId,
        Uint8List.fromList(messageJson.codeUnits),
      );
    } catch (e) {
      print('Error sending payload to $endpointId: $e');
    }
  }

  void _addSystemMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        senderName: 'System',
        senderId: 'system',
        timestamp: DateTime.now(),
        isSystemMessage: true,
      ));
    });
  }

  void _showError(String message) {
    // No-op: Remove red SnackBar error notifications as requested
  }

  Future<void> _stopAndGoBack() async {
    await _stopAll();
    setState(() {
      _state = AppState.idle;
      _userRole = UserRole.none;
    });
  }

  Future<void> _stopAll() async {
    try {
      await NetworkManager.stopAdvertising();
      await NetworkManager.stopDiscovery();
      await NetworkManager.stopAllEndpoints();
    } catch (e) {
      print('Error during cleanup: $e');
    }

    setState(() {
      _connectedClients.clear();
      _hostEndpointId = null;
      _messages.clear();
    });
  }
}

