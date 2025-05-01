import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FoodItem {
  final String id;
  final String name;
  final int yesCount;
  final int noCount;

  FoodItem({
    required this.id,
    required this.name,
    required this.yesCount,
    required this.noCount,
  });
}

class FoodListScreen extends StatefulWidget {
  final String documentId;

  const FoodListScreen({Key? key, required this.documentId}) : super(key: key);

  @override
  FoodListScreenState createState() => FoodListScreenState();
}

class FoodListScreenState extends State<FoodListScreen> {
  List<FoodItem> foodItems = [];

  @override
  void initState() {
    super.initState();
    _loadFood();
  }

  Future<void> _loadFood() async {
    final foodCollection = FirebaseFirestore.instance
        .collection('events')
        .doc(widget.documentId)
        .collection('food');

    final snapshot = await foodCollection.get();

    final loaded = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return FoodItem(
        id: doc.id,
        name: data['name'] as String,
        yesCount: data['yes'] ?? 0,
        noCount: data['no'] ?? 0,
      );
    }).toList();

    setState(() => foodItems = loaded);
  }

  Future<void> _addFood(String name) async {
    if (name.isEmpty) return;
    final foodCollection = FirebaseFirestore.instance
        .collection('events')
        .doc(widget.documentId)
        .collection('food');

    await foodCollection.add({
      'name': name,
      'yes': 0,
      'no': 0,
      'votes': {},
    });

    _loadFood();
  }

  void _showAddFoodDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFD0E4F7),
        title: const Text('Добавить блюдо',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Название блюда'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _addFood(controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Добавить'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD0E4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD0E4F7),
        centerTitle: true,
        title: const Text('Меню', style: TextStyle(color: Colors.black)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          final item = foodItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text(item.name),
              subtitle: Text('✅ ${item.yesCount}   ❌ ${item.noCount}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFoodDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
