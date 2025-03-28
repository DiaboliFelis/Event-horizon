import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:event_horizon/presentation/pages/information_about_the_event/information_about_the_event.dart';
import 'package:intl/intl.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFD8ECFF),
      appBar: CustomAppBar(),
      resizeToAvoidBottomInset: true, //  Убедись, что это значение true
      body: SafeArea(
        // Оборачиваем тело в SafeArea
        child: SingleChildScrollView(
          child: CustomBody(),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF4F81A3),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(15.0);
}

class CustomBody extends StatefulWidget {
  // Изменили на StatefulWidget
  const CustomBody({Key? key}) : super(key: key);

  @override
  State<CustomBody> createState() => _CustomBodyState();
}

// Функция для определения, прошло ли мероприятие
bool isEventPassed(String eventDateString, String eventTimeString) {
  try {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final timeFormat = DateFormat('HH:mm');

    final eventDate = dateFormat.parse(eventDateString);
    final eventTime = timeFormat.parse(eventTimeString);

    final eventDateTime = DateTime(
      eventDate.year,
      eventDate.month,
      eventDate.day,
      eventTime.hour,
      eventTime.minute,
    );

    print('eventDateTime: ${eventDateTime.toLocal()}');
    print('now: ${DateTime.now().toLocal()}');
    bool isAfter = eventDateTime.isAfter(DateTime.now());
    print('isAfter: $isAfter');

    return isAfter;
  } catch (e) {
    print('Ошибка при парсинге даты и времени: $e');
    return false;
  }
}

class _CustomBodyState extends State<CustomBody> {
  String _searchText = ''; // Добавили состояние для хранения текста поиска

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(17.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Строка для кнопки поиска и кнопки аккаунта
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Поиск мероприятия',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (text) {
                    setState(() {
                      _searchText = text;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10), // Промежуток между кнопками
              // Кнопка перехода на аккаунт
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context,
                      '/profile'); // Действие для перехода к виджету аккаунта
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF4F81A3), // Цвет кнопки аккаунта
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 30),
              ),
            ],
          ),
          const SizedBox(
              height: 20), // Расстояние между кнопкой поиска и контейнером
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF4F81A3),
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  children: const [
                    Text(
                      'Список предстоящих мероприятий',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('events')
                        .where('userId',
                            isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        print(
                            "Ошибка StreamBuilder: ${snapshot.error}"); // ВАЖНО: Логируем ошибку
                        return Center(
                            child: Text(
                                'Ошибка загрузки данных: ${snapshot.error}')); // Показываем ошибку на экране
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // <-  Получаем _ВСЕ_ документы из Firestore:
                      final allEvents = snapshot.data!.docs;

                      // Отфильтровываем мероприятия по поиску и по дате
                      final filteredEvents = allEvents.where((event) {
                        final eventData = event.data() as Map<String, dynamic>;
                        final title = (eventData['eventName']?.toString() ?? '')
                            .toLowerCase();
                        final query = _searchText.toLowerCase();
                        final eventDate =
                            eventData['eventDate'] as String? ?? '';
                        final eventTime =
                            eventData['eventTime'] as String? ?? '';

                        // Проверяем и поиск, и дату
                        return title.contains(query) &&
                            (eventDate.isNotEmpty && eventTime.isNotEmpty
                                ? isEventPassed(
                                    eventDate, eventTime) // Проверяем дату
                                : false); // Если даты нет, не показываем
                      }).toList();

                      return ListView.builder(
                        itemCount: filteredEvents.length,
                        itemBuilder: (context, index) {
                          final document = filteredEvents[index];
                          final eventName = document['eventName'] as String? ??
                              'Без названия';
                          final eventDate = document['eventDate'] as String? ??
                              'Дата не указана'; // Получаем дату
                          final documentId = document.id;

                          return ElevatedButton(
                            // Use ElevatedButton instead of Container
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(8.0),
                              backgroundColor: Colors
                                  .transparent, // Make button background transparent
                              shadowColor: Colors.transparent, // Remove shadow
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EventInfoScreen(documentId: documentId),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    eventName, // Название мероприятия из Firebase
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    eventDate, // Дата мероприятия из Firebase
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context,
                    '/create_event'); // Действие для создания мероприятия
              },
              child: const Text(
                'Создать мероприятие',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context,
                        '/my_event'); // Действие для отображения "Мои Мероприятия"
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Мои',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'мероприятия',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 10), // Промежуток между кнопками
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context,
                        '/archive_of_events'); // Действие для отображения "Архив Мероприятий"
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Архив',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'мероприятий',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
