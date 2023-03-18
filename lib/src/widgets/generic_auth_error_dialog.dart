import 'package:flutter/material.dart';

class GenericAuthErrorDialog extends StatelessWidget {
  const GenericAuthErrorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Local authentication'),
      content: const Text('An error has occurred, please try again.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
