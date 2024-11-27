//import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Для форматирования даты и времени

class EventInfoScreen extends StatelessWidget {
  final String eventName;
  final String eventType;
  final DateTime eventDate;
  final TimeOfDay eventTime;
  final String eventAddress;

  EventInfoScreen({
    Key? key,
    required this.eventName,
    required this.eventType,
    required this.eventDate,
    required this.eventTime,
    required this.eventAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy'); // Формат даты
    final timeFormat = DateFormat('HH:mm'); // Формат времени

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

    Widget _buildRoundedTextFormField({
      required String hintText,
      int maxLines = 1,
      TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validator,
      Color boxColor = const Color(0xA64F81A3),
      Color textColor = Colors.black,
    }) {
      return SizedBox(
        width: 351,
        height: 40,
        child: Container(
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.all(3),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
            maxLines: maxLines,
            keyboardType: keyboardType,
            validator: validator,
            style: TextStyle(color: textColor),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    //Функция для создания закругленного контейнера с заголовком
    Widget _buildRoundedTitle(String title, Size size) {
      return Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xA64F81A3),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFD0E4F7),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Для прокрутки, если контент будет больше экрана
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .stretch, // Растягиваем элементы на всю ширину
            children: [
              _buildRoundedTitle(eventName, const Size(351, 60)),
              SizedBox(height: 250),
              _buildRoundedTextFormField(hintText: eventType),
              SizedBox(height: 16),
              _buildRoundedTextFormField(
                  hintText: dateFormat.format(eventDate)),
              SizedBox(height: 16),
              _buildRoundedTextFormField(
                hintText: timeFormat.format(
                    DateTime(2000, 1, 1, eventTime.hour, eventTime.minute)),
              ),
              SizedBox(height: 16),
              _buildRoundedTextFormField(hintText: eventAddress),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRoundedButton(
                      context,
                      'Меню',
                      () => Navigator.pushNamed(context, '/menu'),
                      const Color(0xFFD9D9D9),
                      const Size(160, 70)),
                  _buildRoundedButton(
                      context,
                      'Список гостей',
                      () => Navigator.pushNamed(context, '/guestlist'),
                      const Color(0xFFD9D9D9),
                      const Size(160, 70)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRoundedButton(
                      context,
                      'Назад',
                      () => Navigator.pop(context),
                      const Color(0xFFD9D9D9),
                      const Size(160, 70)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
