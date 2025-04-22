import 'package:dirassati/core/shared_constants.dart';
import 'package:flutter/material.dart';

class BackendIpEditor extends StatefulWidget {
  const BackendIpEditor({Key? key}) : super(key: key);

  @override
  State<BackendIpEditor> createState() => _BackendIpEditorState();
}

class _BackendIpEditorState extends State<BackendIpEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: BackendProvider.backendProviderIp,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final newIp = _controller.text.trim();
    if (newIp.isNotEmpty) {
      await BackendProvider.setBackendProviderIp(newIp);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Backend IP updated!')),
      );
      setState(() {}); // refresh display
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Text('Current IP: ${BackendProvider.backendProviderIp}'),
      ],
    );
  }
}
