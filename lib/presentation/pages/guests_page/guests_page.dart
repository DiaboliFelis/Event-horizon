//Список гостей

import 'package:flutter/material.dart';

class GuestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GuestListScreen();
  }
}

class GuestListScreen extends StatefulWidget {
  @override
  GuestListScreenState createState() => GuestListScreenState();
}

class GuestListScreenState extends State<GuestListScreen> {
  final List<String> guests = [];

  void _addGuest(String name) {
    if (name.isNotEmpty) {
      setState(() {
        guests.add(name);
      });
    }
  }

  void _showAddGuestDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавить гостя'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Введите имя гостя'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String guestName = controller.text;
                _addGuest(guestName);
                Navigator.of(context).pop(); // Закрыть диалог
              },
              child: const Text('Добавить'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог без добавления
              },
              child: const Text('Отмена'),
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
        title: const Center(child: Text('Список гостей')),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: guests.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: const Icon(Icons.account_circle_outlined),
                        title: Card(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10),
                              child: Text(guests[index])),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGuestDialog,
        tooltip: 'Добавить гостя',
        child: const Icon(Icons.add),
      ),
    );
  }
}
