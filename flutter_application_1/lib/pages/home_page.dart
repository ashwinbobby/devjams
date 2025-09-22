import 'package:flutter/material.dart';
import '../main.dart';

class HomePage extends StatelessWidget {
  final AppState state;
  final UserRole userRole;
  final Map<String, String> connectedClients;
  const HomePage({
    Key? key,
    required this.state,
    required this.userRole,
    required this.connectedClients,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state == AppState.hosting) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'You are hosting.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'Waiting for more clients to join...',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else if (state == AppState.discovering) {
      return const Center(child: CircularProgressIndicator());
    } else if (state == AppState.connected) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'You are connected to the host.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
