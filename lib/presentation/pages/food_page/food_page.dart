//Меню

import 'package:flutter/material.dart';

class FoodPage extends StatelessWidget {
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
  final List<String> wishes = [];

  void _addGuest(String name) {
    if (name.isNotEmpty) {
      setState(() {
        wishes.add(name);
      });
    }
  }

  void _showAddGuestDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавить блюдо'),
          content: TextField(
            controller: controller,
            decoration:
                const InputDecoration(labelText: 'Введите название блюда'),
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
        title: Center(child: const Text('Меню')),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: wishes.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: Icon(Icons.account_circle_outlined),
                        title: Card(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10),
                              child: Text(wishes[index])),
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
        tooltip: 'Добавить блюдо в меню',
        child: const Icon(Icons.add),
      ),
    );
  }
}