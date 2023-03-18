import 'package:flutter/material.dart';

class NoBiometricsEnrolledDialog extends StatelessWidget {
  const NoBiometricsEnrolledDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Local authentication'),
      content: const Text('No biometrics enrolled. Please add one on your\'s device settings.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
