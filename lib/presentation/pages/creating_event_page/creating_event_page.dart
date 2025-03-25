import 'package:firebase_auth/firebase_auth.dart';
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
  TextEditingController customEventTypeController = TextEditingController();
  String? selectedEventType;
  bool showTextField = false;

  @override
  void initState() {
    super.initState();
    final uuid = Uuid();
    tempDocumentId = uuid.v4(); //  Генерируем tempDocumentId при инициализации
    documentId = tempDocumentId; //  Назначаем tempDocumentId как documentId
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDescriptionController.dispose();
    _eventAddressController.dispose();
    _eventDateController.dispose();
    _eventTimeController.dispose();
    customEventTypeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    try {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Выберите дату'),
            content: SizedBox(
              width: 300,
              height: 400,
              child: CalendarDatePicker(
                // Или любой другой виджет выбора даты
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                onDateChanged: (DateTime newDate) {
                  setState(() {
                    _eventDateController.text =
                        DateFormat('dd.MM.yyyy').format(newDate);
                  });
                  Navigator.pop(context); // Закрыть диалог
                },
              ),
            ),
          );
        },
      );
    } catch (e) {
      print('Ошибка в _selectDate: $e');
    }
  }

// Валидатор для времени. Проверяет формат "ЧЧ:мм" (без изменений)
  String? _validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите время в формате ЧЧ:мм';
    }
    try {
      DateFormat("HH:mm").parseStrict(value);
      return null;
    } catch (e) {
      return 'Неверный формат времени.  Используйте формат ЧЧ:мм';
    }
  }

  // Функция для выбора времени
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _eventTimeController.text =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Widget _buildRoundedTextFormField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    required void Function(String?)? onSaved,
    bool readOnly = false,
    Widget? suffixIcon,
    VoidCallback? onTap,
  }) {
    return ConstrainedBox(
      // Add ConstrainedBox
      constraints: const BoxConstraints(
        maxHeight: 75.0, // Adjust maxHeight as needed
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
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
          errorMaxLines: 1,
          suffixIcon: suffixIcon, // Limit error lines
        ),
        validator: validator,
        onSaved: onSaved, // Привязываем onSaved к TextFormField
      ),
    );
  }

  // Обработчик сохранения данных
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String eventTypeToSave;
      if (selectedEventType == 'Другое') {
        eventTypeToSave = customEventTypeController.text;
      } else {
        eventTypeToSave = selectedEventType!;
      }

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final eventData = {
            'eventName': _eventNameController.text,
            'eventDescription': _eventDescriptionController.text,
            'eventAddress': _eventAddressController.text,
            'eventDate': _eventDateController.text,
            'eventTime': _eventTimeController.text,
            'eventType': eventTypeToSave,
            'userId': user.uid, //  Сохраняем ID пользователя
          };

          // Сохраняем данные в Firestore
          await FirebaseFirestore.instance
              .collection('events')
              .doc(tempDocumentId)
              .set(eventData);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Данные сохранены')),
          );

          tempDocumentId = null;

          Navigator.pushNamed(
            context,
            '/eventInfo',
            arguments: {'documentId': documentId},
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Пользователь не авторизован')),
          );
        }
      } catch (e) {
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
                      hintText: 'Дата мероприятия',
                      readOnly: true,
                      onTap: () {
                        print('onTap triggered');
                        _selectDate(context);
                      },
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () {
                          print('IconButton onPressed triggered');
                          _selectDate(context);
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Выберите дату мероприятия';
                        }
                        return null;
                      },
                      onSaved: (value) {},
                    ),
                    const SizedBox(height: 10),
                    _buildRoundedTextFormField(
                      controller: _eventTimeController,
                      hintText: 'Время мероприятия',
                      readOnly: true, //  Добавлено
                      onTap: () => _selectTime(context), //  Изменено
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.access_time), //  Изменено
                        onPressed: () => _selectTime(context), //  Изменено
                      ),
                      validator: _validateTime,
                      onSaved: (newValue) {},
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
                () => Navigator.pushNamed(
                  context,
                  '/wishlist',
                  arguments: {
                    'documentId': tempDocumentId
                  }, //  Передаем tempDocumentId
                ),
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
}
