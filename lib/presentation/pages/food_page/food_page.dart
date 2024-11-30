//Меню

import 'package:flutter/material.dart';

class FoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FoodListScreen();
  }
}

class FoodListScreen extends StatefulWidget {
  @override
  FoodListScreenState createState() => FoodListScreenState();
}

class FoodListScreenState extends State<FoodListScreen> {
  final List<String> food = [];

  void _addFood(String name) {
    if (name.isNotEmpty && !food.contains(name)) {
      setState(() {
        food.add(name);
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
              child:  Card( 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              color: const Color(0x993C3C43),
              child: const Padding(
                padding:  EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                child:  Text('Добавить блюдо', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),),
              ),
              ),
            ),
          ),
          content: Card( 
            color: Color(0xA64F81A3),
            child: 
            TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Введите название блюда'),
          ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String food = controller.text;
                _addFood(food);
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
          margin: EdgeInsets.all(100),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          color: Color(0x993C3C43),
          child: const Padding
          (
            padding: EdgeInsets.all(15) ,
            child: Center
            (
            child: Text('Меню', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))
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
                  itemCount: food.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Card(
                            color: const Color(0xA64F81A3),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                              child: Row( children: [
                                Text(food[index], style: TextStyle(color: Colors.white),)
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
        onPressed: _showAddFoodDialog,
        tooltip: 'Добавить блюдо в меню',
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}
