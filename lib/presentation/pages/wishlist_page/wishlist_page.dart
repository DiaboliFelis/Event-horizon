import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WishlistListScreen extends StatefulWidget {
  final String documentId;

  const WishlistListScreen({Key? key, required this.documentId})
      : super(key: key);

  @override
  wishlistListScreenState createState() => wishlistListScreenState();
}

class wishlistListScreenState extends State<WishlistListScreen> {
  final List<String> wishlist = [];

  void _addWish(String name) async {
    if (name.isNotEmpty) {
      // 1. Получаем ссылку на коллекцию "food" для конкретного мероприятия
      final WishCollection = FirebaseFirestore.instance
          .collection('events')
          .doc(widget
              .documentId) //  Замени widget.documentId на правильный documentId
          .collection('Wishlist');

      // 2. Добавляем новое блюдо в коллекцию
      await WishCollection.add({'name': name});

      // 3. Обновляем локальное состояние (если нужно)
      setState(() {
        wishlist.add(name);
      });
    }
  }

  void _showAddFoodDialog() {
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
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                color: const Color(0x993C3C43),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                  child: Text(
                    'Добавить желание',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          content: Card(
            color: const Color(0xA64F81A3),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Введите желание'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String wishlist = controller.text;
                _addWish(wishlist);
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
        title: SizedBox(
          width: 200,
          height: 60,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            color: const Color(0x993C3C43),
            child: const Padding(
              padding: EdgeInsets.all(0),
              child: Center(
                child: Text('Вишлист',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
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
                  itemCount: wishlist.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        color: const Color(0xA64F81A3),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10),
                            child: Text(
                              wishlist[index],
                              style: const TextStyle(color: Colors.white),
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
        onPressed: () => _showAddFoodDialog(),
        tooltip: 'Добавить жедание',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
