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
  List<String> wishlist = [];

  @override
  void initState() {
    super.initState();
    _loadWish(); // Загрузка данных при инициализации виджета
  }

  Future<void> _loadWish() async {
    // 1. Получаем ссылку на коллекцию "food" для конкретного мероприятия
    final foodCollection = FirebaseFirestore.instance
        .collection('events')
        .doc(widget.documentId)
        .collection('Wishlist');

    // 2. Получаем все документы из коллекции
    final snapshot = await foodCollection.get();

    // 3. Преобразуем документы в список названий блюд
    List<String> loadedWish =
        snapshot.docs.map((doc) => doc['name'] as String).toList();

    // 4. Обновляем состояние виджета
    setState(() {
      wishlist = loadedWish;
    });
  }

  Future<void> _addWish(String name) async {
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
      _loadWish();
    }
  }

  void _showAddFoodDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFD0E4F7),
          title: Text(
            'Добавить желание',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Введите желание'),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFD0E4F7),
        title: SizedBox(
//            width: 200,
//            height: 60,
//           child: Card(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(100)),
//            color: const Color(0x993C3C43),
//             child: const Padding(
//               padding: EdgeInsets.all(0),
          child: Text('Вишлист', style: TextStyle(color: Colors.black)),
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
                        color: const Color(0xFFD0E4F7),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10),
                            child: Text(
                              wishlist[index],
                              style: const TextStyle(color: Colors.black),
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
//        backgroundColor: const Color(0x993C3C43),
        onPressed: () => _showAddFoodDialog(),
        tooltip: 'Добавить жедание',
        child: const Icon(
          Icons.add,
//          color: Colors.white,
        ),
      ),
    );
  }
}
