import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InformationFoodPage extends StatefulWidget {
  final String documentId;

  const InformationFoodPage({Key? key, required this.documentId})
      : super(key: key);

  @override
  State<InformationFoodPage> createState() => _InformationFoodPageState();
}

class _InformationFoodPageState extends State<InformationFoodPage> {
  List<String> food = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFood();
  }

  Future<void> _loadFood() async {
    try {
      // 1. Получаем ссылку на коллекцию "food" для конкретного мероприятия
      final foodCollection = FirebaseFirestore.instance
          .collection('events')
          .doc(widget.documentId)
          .collection('food');

      // 2. Получаем все документы из этой коллекции
      final snapshot = await foodCollection.get();

      // 3. Преобразуем документы в список названий блюд
      List<String> loadedFood =
          snapshot.docs.map((doc) => doc['name'] as String).toList();

      // 4. Обновляем состояние виджета
      setState(() {
        food = loadedFood;
        _errorMessage = null;
      });
    } catch (e) {
      print('Error loading food: $e');
      _errorMessage = 'Ошибка при загрузке блюд: $e';
      setState(() {});
    }
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
                child: Text('Меню',
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
              // 5. Отображаем сообщение об ошибке, если оно есть
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(_errorMessage!),
                ),
              // 6. Отображаем список блюд
              Expanded(
                child: ListView.builder(
                  itemCount: food.length,
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
                              food[index],
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
    );
  }
}
