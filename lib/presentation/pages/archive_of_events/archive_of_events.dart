import 'package:event_horizon/presentation/pages/information_about_the_event/information_about_the_event.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

bool isEventPassed(String eventDateString, String eventTimeString) {
  try {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final timeFormat = DateFormat('HH:mm');

    final eventDate = dateFormat.parse(eventDateString);
    final eventTime = timeFormat.parse(eventTimeString);

    final eventDateTime = DateTime(
      eventDate.year,
      eventDate.month,
      eventDate.day,
      eventTime.hour,
      eventTime.minute,
    );
    print('Event Date and Time: $eventDateTime');
    print('Current Date and Time: ${DateTime.now()}');
    return eventDateTime.isBefore(DateTime.now()); // Проверяем, что событие в прошлом
  } catch (e) {
    print('Ошибка при парсинге даты и времени: $e');
    return false;
  }
}

class ArchiveOfEventsPage extends StatelessWidget {
  final String? eventDate;
  final String? eventTime;
  const ArchiveOfEventsPage({Key? key, this.eventDate, this.eventTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD8ECFF),
        title: const Text('Архив мероприятий'),
      ),
      body: MyEvents(),
    );
  }
}

class MyEvents extends StatelessWidget {
  const MyEvents({Key? key}) : super(key: key);

  Future<void> _deletePassedEvents(List<QueryDocumentSnapshot> docs) async {
    for (final doc in docs) {
      final eventData = doc.data() as Map<String, dynamic>;
      final eventDate = eventData['eventDate'] as String? ?? '';
      final eventTime = eventData['eventTime'] as String? ?? '';

      if (eventDate.isNotEmpty &&
          eventTime.isNotEmpty &&
          isEventPassed(eventDate, eventTime)) {
        await FirebaseFirestore.instance
            .collection('events')
            .doc(doc.id)
            .delete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD8ECFF),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("Ошибка StreamBuilder: ${snapshot.error}");
            return Center(
                child: Text('Ошибка загрузки данных: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Получаем все документы
          final allDocs = snapshot.data!.docs;

          // Фильтруем только прошедшие события
          final pastEvents = allDocs.where((doc) {
            final eventData = doc.data() as Map<String, dynamic>;
            final eventDate = eventData['eventDate'] as String? ?? '';
            final eventTime = eventData['eventTime'] as String? ?? '';

            if (eventDate.isNotEmpty && eventTime.isNotEmpty) {
              return isEventPassed(eventDate, eventTime); // Показываем только прошедшие
            }
            return false; // Игнорируем события без даты и времени
          }).toList();
          
          return ListView.builder(
            itemCount: pastEvents.length,
            itemBuilder: (context, index) {
              final document = pastEvents[index];
              final eventData = document.data() as Map<String, dynamic>;
              final eventName = eventData['eventName'] as String? ?? 'Без названия';
              final documentId = document.id;

              return EventListItem(
                documentId: documentId,
                eventName: eventName,
              );
            },
          );
        },
      ),
    );
  }
}

class EventListItem extends StatelessWidget {
  final String documentId;
  final String eventName;
  const EventListItem({
    Key? key,
    required this.documentId,
    required this.eventName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(eventName),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventInfoScreen(documentId: documentId),
                ),
              );
          },
        ),
      ),
    );
  }
}