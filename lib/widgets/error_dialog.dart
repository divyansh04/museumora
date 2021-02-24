import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  static Future<void> showErrorDialog(BuildContext context,
      {String error, String title}) async {
    await showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              title: Text(title ?? 'title'),
              children: [Text(error ?? "error")],
            ));
  }
}
