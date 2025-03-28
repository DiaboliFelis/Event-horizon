import 'package:flutter/material.dart';

class EventDetailsDialog extends StatelessWidget {
  final String description;

  const EventDetailsDialog({Key? key, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Описание мероприятия'),
      content: SingleChildScrollView(
        child: Text(description),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Закрыть'),
        ),
      ],
    );
  }
}
