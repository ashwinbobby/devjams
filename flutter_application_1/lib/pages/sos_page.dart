import 'package:flutter/material.dart';

class SosPage extends StatelessWidget {
  final VoidCallback onSendSos;
  const SosPage({Key? key, required this.onSendSos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Send an SOS to all devices',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: onSendSos,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(40),
              elevation: 8,
            ),
            child: const Text(
              'SOS',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
          ),
        ],
      ),
    );
  }
}
