import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:event_horizon/presentation/pages/information_about_the_event/information_about_the_event.dart';
import 'package:intl/intl.dart';
import 'package:event_horizon/presentation/pages/menu_page/cloud_widget.dart';
import 'package:event_horizon/presentation/pages/menu_page/cloud_1_widget.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8ECFF),
      appBar: const CustomAppBar(),
      resizeToAvoidBottomInset: true, // Убедись, что это значение true
      body: Stack(
        // Используем Stack для наложения облаков на фон
        children: [
          CloudBackground(),
          Cloud_1_Background(),
          SafeArea(
            child: CustomBody(),
          ),
        ],
      ),
    );
  }
}

class CloudBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    const int cloudCountHorizontal = 1; // Количество облаков по горизонтали
    const int cloudCountVertical = 2; // Количество облаков по вертикали

    const double horizontalSpacingFactor =
        0.2; // Увеличиваем горизонтальный отступ МЕЖДУ облаками
    const double verticalSpacingFactor =
        0.0001; // Увеличиваем вертикальный отступ МЕЖДУ облаками

    // Вычисляем ширину области, занимаемой облаками
    final double totalCloudAreaWidth = screenWidth /
        (1 +
            (cloudCountHorizontal - 1) *
                (horizontalSpacingFactor - 1) /
                cloudCountHorizontal);
    final double totalCloudAreaHeight = screenHeight /
        (1 +
            (cloudCountVertical - 1) *
                (verticalSpacingFactor - 1) /
                cloudCountVertical);

    // Вычисляем отступы внутри этой области
    final double horizontalSpacing =
        totalCloudAreaWidth / (cloudCountHorizontal + 1);
    final double verticalSpacing =
        totalCloudAreaHeight / (cloudCountVertical + 1);

    // Вычисляем смещение, чтобы центрировать область с облаками
    final double horizontalOffset = (screenWidth - totalCloudAreaWidth) / 1;
    final double verticalOffset = (screenHeight - totalCloudAreaHeight) / 1.5;

    return Stack(
      children: [
        ...List.generate(
          cloudCountHorizontal * cloudCountVertical,
          (index) {
            final int row = index ~/ cloudCountHorizontal; // Номер строки
            final int col = index % cloudCountHorizontal; // Номер столбца

            final double x = horizontalOffset +
                horizontalSpacing * (col + 0.03); // Добавляем смещение
            final double y = verticalOffset +
                verticalSpacing * (row + 1.09); // Добавляем смещение

            return CloudWidget(
              x: x,
              y: y,
            );
          },
        ),
      ],
    );
  }
}

class Cloud_1_Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    const int cloudCountHorizontal = 1; // Количество облаков по горизонтали
    const int cloudCountVertical = 2; // Количество облаков по вертикали

    const double horizontalSpacingFactor =
        0.1; // Увеличиваем горизонтальный отступ МЕЖДУ облаками
    const double verticalSpacingFactor =
        0.0001; // Увеличиваем вертикальный отступ МЕЖДУ облаками

    // Вычисляем ширину области, занимаемой облаками
    final double totalCloudAreaWidth = screenWidth /
        (1 +
            (cloudCountHorizontal - 1) *
                (horizontalSpacingFactor - 1) /
                cloudCountHorizontal);
    final double totalCloudAreaHeight = screenHeight /
        (1 +
            (cloudCountVertical - 1) *
                (verticalSpacingFactor - 1) /
                cloudCountVertical);

    // Вычисляем отступы внутри этой области
    final double horizontalSpacing =
        totalCloudAreaWidth / (cloudCountHorizontal + 1);
    final double verticalSpacing =
        totalCloudAreaHeight / (cloudCountVertical + 1);

    // Вычисляем смещение, чтобы центрировать область с облаками
    final double horizontalOffset = (screenWidth - totalCloudAreaWidth) / 1.5;
    final double verticalOffset = (screenHeight - totalCloudAreaHeight) / 1.5;

    return Stack(
      children: [
        ...List.generate(
          cloudCountHorizontal * cloudCountVertical,
          (index) {
            final int row = index ~/ cloudCountHorizontal; // Номер строки
            final int col = index % cloudCountHorizontal; // Номер столбца

            final double x = horizontalOffset +
                horizontalSpacing * (col + 1.2); // Добавляем смещение
            final double y = verticalOffset +
                verticalSpacing * (row + 0.98); // Добавляем смещение

            return Cloud_1_Widget(
              x: x,
              y: y,
            );
          },
        ),
      ],
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
      child: SingleChildScrollView(
        reverse: true,
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
                  child:
                      const Icon(Icons.person, color: Colors.white, size: 30),
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
                          .where('attendingUsers',
                              arrayContains: FirebaseAuth.instance.currentUser?.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  'Ошибка загрузки мероприятий'));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        // Получаем все мероприятия без дубликатов
                        final events = snapshot.data!.docs;
                        final filteredEvents = events.where((event) {
                          final eventData =
                              event.data() as Map<String, dynamic>;
                          final title =
                              (eventData['eventName']?.toString() ?? '')
                                  .toLowerCase();
                          final query = _searchText.toLowerCase();
                          final eventDate =
                              eventData['eventDate'] as String? ?? '';
                          final eventTime =
                              eventData['eventTime'] as String? ?? '';

                          // Проверяем и поиск, и дату
                          return title.contains(query) &&
                              (eventDate.isNotEmpty && eventTime.isNotEmpty
                                  ? isEventPassed(eventDate,
                                      eventTime) // Проверяем дату
                                  : false); // Если даты нет, не показываем
                        }).toList();

                        if (filteredEvents.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/catcloud.png', // Путь к картинке котика
                                  width: 100,
                                  height: 100,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Нет мероприятий',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: filteredEvents.length,
                          itemBuilder: (context, index) {
                            final document = filteredEvents[index];
                            final eventName =
                                document['eventName'] as String? ??
                                    'Без названия';
                            final eventDate =
                                document['eventDate'] as String? ??
                                    'Дата не указана'; // Получаем дату
                            final documentId = document.id;

                            return ElevatedButton(
                              // Use ElevatedButton instead of Container
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(8.0),
                                backgroundColor: Colors
                                    .transparent, // Make button background transparent
                                shadowColor:
                                    Colors.transparent, // Remove shadow
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EventInfoScreen(
                                        documentId: documentId),
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
      ),
    );
  }
}