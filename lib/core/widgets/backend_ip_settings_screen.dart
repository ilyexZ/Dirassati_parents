import 'package:dirassati/core/shared_constants.dart';
import 'package:flutter/material.dart';

class BackendIpSettingsScreen extends StatefulWidget {
  const BackendIpSettingsScreen({super.key});

  @override
  State<BackendIpSettingsScreen> createState() => _BackendIpSettingsScreenState();
}

class _BackendIpSettingsScreenState extends State<BackendIpSettingsScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: BackendProvider.backendProviderIp);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final ip = _controller.text.trim();
    if (ip.isNotEmpty) {
      await BackendProvider.setBackendProviderIp(ip);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Backend IP saved')),
      );
      setState(() {}); // to refresh display
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backend IP Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Backend IP',
                hintText: 'e.g. 192.168.1.100:5080',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Save'),
            ),
            const SizedBox(height: 20),
            Text('Current IP: ${BackendProvider.backendProviderIp}'),
          ],
        ),
      ),
    );
  }
}
