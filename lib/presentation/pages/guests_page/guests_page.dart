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
  final List<String> wishes = [];

  void _addGuest(String name) {
    if (name.isNotEmpty && !wishes.contains(name)) {
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
          backgroundColor: const Color(0xFFD0E4F7),
          title: SizedBox(
            width: 300,
            height: 100,
            child: Center(
              child:  Card( 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              color: const Color(0x993C3C43),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                child:  Text('Добавить гостя', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),),
              ),
              ),
            ),
          ),
          content: Card( 
            color: const Color(0xA64F81A3),
            child: 
            TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Введите имя гостя'),
          ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String guest = controller.text;
                _addGuest(guest);
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
      backgroundColor: const Color(0xFFD0E4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD0E4F7),
        title: Card
        (
          margin: const EdgeInsets.all(100),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          color:  const Color(0x993C3C43),
          child: const Padding
          (
            padding: EdgeInsets.all(15) ,
            child: Center
            (
            child: Text('Список гостей', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))
            ),
          ),
        ),
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
                          title: Card(
                            color: const Color(0xA64F81A3),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                              child: Row( children: [
                                Text(wishes[index], style: const TextStyle(color: Colors.white),)
                              ]
                            ),
                          ),
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
        backgroundColor: const Color(0x993C3C43),
        onPressed: _showAddGuestDialog,
        tooltip: 'Добавить гостя',
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}
