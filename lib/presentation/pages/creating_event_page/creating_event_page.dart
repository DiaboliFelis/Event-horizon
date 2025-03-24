import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CreatingAnEventPage extends StatefulWidget {
  const CreatingAnEventPage({super.key});

  @override
  State<CreatingAnEventPage> createState() => _CreatingAnEventPageState();
}

class _CreatingAnEventPageState extends State<CreatingAnEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _eventDescriptionController = TextEditingController();
  final _eventAddressController = TextEditingController();
  final _eventDateController = TextEditingController();
  final _eventTimeController = TextEditingController();
  String? eventTypeToSave;
  String? documentId; //  Переменная для хранения documentId
  String? tempDocumentId; //  Переменная для хранения tempDocumentId

  @override
  void initState() {
    super.initState();
    final uuid = Uuid();
    tempDocumentId = uuid.v4(); //  Генерируем tempDocumentId при инициализации
    documentId = tempDocumentId; //  Назначаем tempDocumentId как documentId
  }

  // Валидатор для даты. Проверяет формат "ДД.ММ.ГГГГ"
  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите дату в формате ДД.ММ.ГГГГ';
    }
    try {
      final parsedDate = DateFormat("dd.MM.yyyy").parse(value);
      if (parsedDate
          .isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
        // Сравниваем с "вчера", чтобы разрешить текущую дату
        return 'Дата должна быть сегодняшней или будущей';
      }
      return null; // Дата валидна
    } catch (e) {
      return 'Неверный формат даты';
    }
  }

  // Валидатор для времени. Проверяет формат "ЧЧ:мм"
  String? _validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите время в формате ЧЧ:мм';
    }
    try {
      DateFormat("HH:mm").parse(value);
      return null; // Время валидно
    } catch (e) {
      return 'Неверный формат времени';
    }
  }

  Widget _buildRoundedTextFormField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    required void Function(String?)? onSaved,
  }) {
    return ConstrainedBox(
      // Add ConstrainedBox
      constraints: const BoxConstraints(
        maxHeight: 75.0, // Adjust maxHeight as needed
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: const Color(0xA64F81A3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          errorStyle: const TextStyle(
              fontSize: 10, color: Colors.red), // Adjust error style
          errorMaxLines: 1, // Limit error lines
        ),
        validator: validator,
        onSaved: onSaved, // Привязываем onSaved к TextFormField
      ),
    );
  }

  // Обработчик сохранения данных
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Вызываем save() для сохранения данных

      //  Определяем тип мероприятия
      String eventTypeToSave;
      if (selectedEventType == 'Другое') {
        eventTypeToSave = customEventTypeController.text; // Из поля "Другое"
      } else {
        eventTypeToSave = selectedEventType!; // Из выпадающего списка
      }

      // Создаем карту с данными
      final eventData = {
        'eventName': _eventNameController.text,
        'eventDescription': _eventDescriptionController.text,
        'eventAddress': _eventAddressController.text,
        'eventDate': _eventDateController.text,
        'eventTime': _eventTimeController.text,
        'eventType': eventTypeToSave, //  Сохраняем тип мероприятия
      };

      try {
        // Сохраняем данные в Firestore и получаем DocumentReference
        await FirebaseFirestore.instance
            .collection('events')
            .doc(tempDocumentId) //  Используем tempDocumentId при сохранении
            .set(eventData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Данные сохранены')),
        );

        // Получаем ID документа
        tempDocumentId = null; //  Удаляем tempDocumentId

        // Используем Navigation.generateRoute для перехода
        Navigator.pushNamed(
          context,
          '/eventInfo',
          arguments: {'documentId': documentId}, // Передаем documentId
        );
      } catch (e) {
        // Обрабатываем ошибки
        print('Ошибка при сохранении в Firestore: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка сохранения: $e')),
        );
      }
    }
  }

  // Функция для создания закруглённой кнопки
  Widget _buildRoundedButton(BuildContext context, String text,
      VoidCallback onPressed, Color buttonColor, Size size) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.black,
          textStyle: const TextStyle(
              fontSize: 16), //Настройте размер шрифта если нужно
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  //Функция для создания закругленного контейнера с заголовком
  Widget _buildRoundedTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0x993C3C43),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String? selectedEventType; // объявьте переменную вне build
  bool showTextField = false; // для отображения текстового поля
  TextEditingController customEventTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFD0E4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD0E4F7),
        title: const Text('Создание мероприятия'),
      ),
      body: ListView(
        // Use Stack
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // _buildRoundedTitle('Создание мероприятия'),
                    _buildRoundedTextFormField(
                      controller: _eventNameController,
                      hintText: 'Название мероприятия',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите название мероприятия';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        // Сохраняем данные (например, в переменную eventName)
                        // eventName = newValue; // Если нужно, создайте переменную
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildRoundedTextFormField(
                      controller: _eventDescriptionController,
                      hintText: 'Описание мероприятия',
                      validator: (value) {
                        // Ваш валидатор для описания
                        return null;
                      },
                      onSaved: (newValue) {
                        // eventDescription = newValue;
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildRoundedTextFormField(
                      controller: _eventDateController,
                      hintText: 'ДД.ММ.ГГ',
                      keyboardType: TextInputType.datetime,
                      validator: _validateDate,
                      onSaved: (newValue) {
                        // eventDate = newValue;
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildRoundedTextFormField(
                      controller: _eventTimeController,
                      hintText: 'Время мероприятия',
                      keyboardType: TextInputType.datetime,
                      validator: _validateTime,
                      onSaved: (newValue) {
                        // eventTime = newValue;
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildRoundedTextFormField(
                      controller: _eventAddressController,
                      hintText: 'Адрес мероприятия',
                      validator: (value) {
                        // Ваш валидатор для адреса
                        return null;
                      },
                      onSaved: (newValue) {
                        // eventAddress = newValue;
                      },
                    ),
                    const SizedBox(height: 15),

                    // Ряд кнопок "Меню" и "Список гостей"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildRoundedButton(
                            context,
                            'Меню',
                            () => Navigator.pushNamed(
                                  context,
                                  '/food',
                                  arguments: {
                                    'documentId': tempDocumentId
                                  }, //  Передаем tempDocumentId
                                ),
                            const Color(0xFFD9D9D9),
                            const Size(160, 60)),
                        _buildRoundedButton(
                            context,
                            'Список гостей',
                            () => Navigator.pushNamed(context, '/guest'),
                            const Color(0xFFD9D9D9),
                            const Size(160, 60)),
                      ],
                    ),

                    const SizedBox(height: 15), // Отступ

                    DropdownButtonFormField<String>(
                      value: selectedEventType,
                      decoration: InputDecoration(
                        labelText: 'Тип мероприятия',
                        labelStyle:
                            TextStyle(color: Colors.black), // Стиль подписи
                        hintText: 'Выберите тип', // Подсказка
                        hintStyle:
                            TextStyle(color: Colors.black), // Стиль подсказки
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(50), // Скругленные углы
                          borderSide: BorderSide(
                            color: const Color(0xA64F81A3),
                          ), // Цвет рамки
                        ),
                        enabledBorder: OutlineInputBorder(
                            // Рамка, когда поле активно
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: const Color(0xA64F81A3),
                            )),
                        focusedBorder: OutlineInputBorder(
                            // Рамка, когда поле в фокусе
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: const Color(0xA64F81A3),
                            )),
                        filled: true, // Заливка фона
                        fillColor: const Color(0xA64F81A3), // Цвет заливки
                      ),
                      items: <String>[
                        'День рождения',
                        'Новый год',
                        'Хеллоуин',
                        'Другое',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedEventType = newValue;
                          showTextField = newValue ==
                              'Другое'; // Показывает текстовое поле, если выбрано "Другое"
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, выберите тип мероприятия';
                        }
                        if (value == 'Другое' &&
                            customEventTypeController.text.isEmpty) {
                          return 'Пожалуйста, введите тип мероприятия';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        selectedEventType = newValue;
                      },
                    ),
                    if (showTextField) // отображает текстовое поле если выбрано "Другое"
                      TextFormField(
                        controller: customEventTypeController,
                        decoration: const InputDecoration(
                            labelText: 'Введите тип мероприятия'),
                        onSaved: (newValue) {
                          //  Сохраняем значение, введенное в поле "Другое"
                          //  Например, можно сохранить его в переменную состояния
                          //  customEventType = newValue;
                        },
                      ), // Отступ
                  ],
                ),
              ),
            ),
          ),
          // Кнопка "Вишлист"
          Positioned(
            // Position the "Add Wishlist" button
            bottom: 110, // Adjust as needed
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: _buildRoundedButton(
                context,
                'Можете добавить вишлист\n         (список желаний)',
                () => Navigator.pushNamed(context, '/wishlist'),
                const Color(0xA64F81A3),
                const Size(280, 75),
              ),
            ),
          ),

          // Ряд кнопок "Назад" и "Сохранить"
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: _buildRoundedButton(
                context,
                'Сохранить',
                _submitForm,
                const Color(0xFFD9D9D9),
                const Size(320, 70),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDescriptionController.dispose();
    _eventAddressController.dispose();
    _eventDateController.dispose();
    _eventTimeController.dispose();
    super.dispose();
  }
}
