import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InformationFoodPage extends StatefulWidget {
  final String documentId;

  const InformationFoodPage({Key? key, required this.documentId})
      : super(key: key);

  @override
  State<InformationFoodPage> createState() => _InformationFoodPageState();
}

class _InformationFoodPageState extends State<InformationFoodPage> {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? 'testUser';
  List<DocumentSnapshot> foodDocs = [];
  Map<String, String> userVotes = {};
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFood();
  }

  Future<void> _loadFood() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.documentId)
          .collection('food')
          .get();

      Map<String, String> votes = {};
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['votes'] != null && data['votes'][userId] != null) {
          votes[doc.id] = data['votes'][userId];
        }
      }

      setState(() {
        foodDocs = snapshot.docs;
        userVotes = votes;
        _error = null;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _vote(String foodId, String choice) async {
    final ref = FirebaseFirestore.instance
        .collection('events')
        .doc(widget.documentId)
        .collection('food')
        .doc(foodId);

    final snap = await ref.get();
    final data = snap.data() as Map<String, dynamic>?;
    if (data == null) return;

    final prevVote = data['votes']?[userId];

    if (prevVote == choice) return; // уже проголосовал этим же выбором

    WriteBatch batch = FirebaseFirestore.instance.batch();

    if (prevVote != null) {
      batch.update(ref, {
        prevVote: FieldValue.increment(-1),
        'votes.$userId': FieldValue.delete(),
      });
    }

    batch.update(ref, {
      choice: FieldValue.increment(1),
      'votes.$userId': choice,
    });

    await batch.commit();
    _loadFood();
  }

  Future<void> _cancelVote(String foodId) async {
    final ref = FirebaseFirestore.instance
        .collection('events')
        .doc(widget.documentId)
        .collection('food')
        .doc(foodId);

    final snap = await ref.get();
    final data = snap.data() as Map<String, dynamic>?;
    if (data == null) return;

    final prevVote = data['votes']?[userId];
    if (prevVote == null) return; // нет голоса для отмены

    await ref.update({
      prevVote: FieldValue.increment(-1),
      'votes.$userId': FieldValue.delete(),
    });
    _loadFood();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Меню')),
        body: Center(child: Text('Ошибка: $_error')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Меню')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: foodDocs.length,
        itemBuilder: (context, i) {
          final doc = foodDocs[i];
          final data = doc.data() as Map<String, dynamic>;
          final id = doc.id;
          final yes = data['yes'] ?? 0;
          final no = data['no'] ?? 0;
          final vote = userVotes[id];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text(data['name'] ?? ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('✅ $yes   ❌ $no'),
                  if (vote != null)
                    TextButton(
                      onPressed: () => _cancelVote(id),
                      child: const Text('Отменить голос'),
                    ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.check,
                      color: vote == 'yes' ? Colors.green : null,
                    ),
                    onPressed: () => _vote(id, 'yes'),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: vote == 'no' ? Colors.red : null,
                    ),
                    onPressed: () => _vote(id, 'no'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
