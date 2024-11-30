import 'package:flutter/material.dart';

class MyEventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD8ECFF),
        title: const Text('Мои мероприятия'), // Добавили заголовок
      ),
      body: const MyEvents(),
    );
  }
}

class MyEvents extends StatelessWidget {
  const MyEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD8ECFF),
    ); // Or return any other widget you want as a placeholder
  }
}
