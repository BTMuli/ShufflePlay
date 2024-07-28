// Flutter imports:
import 'package:flutter/material.dart';

class AppConfigPage extends StatelessWidget {
  const AppConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Config'),
      ),
      body: const Center(
        child: Text('App Config Page'),
      ),
    );
  }
}
