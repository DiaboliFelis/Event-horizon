//Список гостей

import 'package:flutter/material.dart';

class GuestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return guestListScreen();
  }
}

class guestListScreen extends StatefulWidget {
  @override
  guestListScreenState createState() => guestListScreenState();
}

class guestListScreenState extends State<guestListScreen> {
  final List<String> guest = [];

  void _addGuest(String name) {
    if (name.isNotEmpty && !guest.contains(name)) {
      setState(() {
        guest.add(name);
      });
    }
  }

  void _showAddguestDialog() {
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
                child: Text('Добавить блюдо', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),),
              ),
              ),
            ),
          ),
          content: Card( 
            color: const Color(0xA64F81A3),
            child: 
            TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Введите название блюда'),
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
        centerTitle: true,
        backgroundColor: const Color(0xFFD0E4F7),
        title: SizedBox
        ( 
          width: 200,
          height: 100,
        child: Card
          (
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          color: const Color(0x993C3C43),
          child: const Padding
            (
            padding: EdgeInsets.all(0) ,
            child: Center
            (
            child: Text('Список гостей', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))
            ),
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
                  itemCount: guest.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Card(
                            color: const Color(0xA64F81A3),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                              child:
                                Text(guest[index], style: const TextStyle(color: Colors.white),
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
        onPressed: _showAddguestDialog,
        tooltip: 'Добавить гостя',
        child: const Icon(Icons.person_add_alt_outlined, color: Colors.white,),
      ),
    );
  }
}
