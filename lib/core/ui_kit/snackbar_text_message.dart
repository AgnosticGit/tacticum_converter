import 'package:flutter/material.dart';
import '../../../main.dart';

class SnackbarTextMessage extends StatelessWidget {
  const SnackbarTextMessage(
    this.message, {
    super.key,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    TacticumConverter.snackbarKey.currentState?.showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.blue[900],
        padding: EdgeInsets.zero,
        content: SnackbarTextMessage(message),
      ),
    );
  }

  static void clearSnackBars() => TacticumConverter.snackbarKey.currentState?.clearSnackBars();
}
