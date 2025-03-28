import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_horizon/presentation/pages/information_about_the_event/information_about_the_event.dart';

class MyEventsPage extends StatelessWidget {
  const MyEventsPage({Key? key}) : super(key: key);

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Дополнительно"),
          content: const Text(
              "Для того, чтобы удалить мероприятие, смахните его влево"),
          actions: [
            TextButton(
              child: const Text("Закрыть"),
              onPressed: () {
                Navigator.of(context).pop(); // Закрываем диалог
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFD8ECFF),
        title: const Text('Мои мероприятия'),
        actions: [
          IconButton(
            icon: const Icon(Icons.question_mark),
            onPressed: () {
              _showOptionsDialog(context);
            },
          ),
        ],
      ),
      body: MyEvents(),
    );
  }
}

class MyEvents extends StatelessWidget {
  const MyEvents({Key? key}) : super(key: key);

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
            print(
                "Ошибка StreamBuilder: ${snapshot.error}"); // ВАЖНО: Логируем ошибку
            return Center(
                child: Text(
                    'Ошибка загрузки данных: ${snapshot.error}')); // Показываем ошибку на экране
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          //  Дальше идет логика, когда данные успешно получены
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final document = snapshot.data!.docs[index];
              final eventName =
                  document['eventName'] as String? ?? 'Без названия';
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

  const EventListItem(
      {Key? key, required this.documentId, required this.eventName})
      : super(key: key);

  Future<void> _deleteEvent(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(documentId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Мероприятие удалено')),
      );
    } catch (e) {
      print("Ошибка удаления: $e"); // ВАЖНО: Логируем ошибку
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка удаления: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(documentId),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        _deleteEvent(context);
      },
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Удалить мероприятие?"),
              content:
                  const Text("Вы уверены, что хотите удалить это мероприятие?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Отмена"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Удалить"),
                ),
              ],
            );
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventInfoScreen(documentId: documentId),
              ),
            );
          },
          child: Padding(
            // Используем Padding для создания отступов внутри InkWell
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  eventName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Icon(
                    Icons.arrow_forward_ios), // Иконка для визуального указания
              ],
            ),
          ),
        ),
      ),
    );
  }
}
