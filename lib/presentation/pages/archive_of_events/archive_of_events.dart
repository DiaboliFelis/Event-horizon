import 'package:flutter/material.dart';

class ArchiveOfEventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD8ECFF),
        title: const Text('Архив мероприятий'), // Добавили заголовок
      ),
      body: const ArchiveOfEvents(),
    );
  }
}

class ArchiveOfEvents extends StatelessWidget {
  const ArchiveOfEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD8ECFF),
    ); // Or return any other widget you want as a placeholder
  }
}
