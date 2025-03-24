//import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_horizon/presentation/pages/information_about_the_event/information_about_the_event_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Для форматирования даты и времени

class EventInfoScreen extends StatelessWidget {
  final String documentId; // Получаем documentId через конструктор

  EventInfoScreen({Key? key, required this.documentId}) : super(key: key);

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
      required String initialValue,
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
            initialValue: initialValue,
            enabled: false,
            decoration: InputDecoration(
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
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD0E4F7),
      ),
      backgroundColor: const Color(0xFFD0E4F7),
      body: BlocProvider<EventCubit>(
        create: (context) => EventCubit()..onPageOpened(documentId),
        child: BlocBuilder<EventCubit, InformationAboutTheEventState>(
          builder: (context, state) {
            if (state is InfAboutTheEventLoadInProgress) {
              return Center(child: CircularProgressIndicator());
            }
            final successState = state as InfAboutTheEventLoadSuccess;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                // Для прокрутки, если контент будет больше экрана
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .stretch, // Растягиваем элементы на всю ширину
                  children: [
                    _buildRoundedTitle(
                        successState.eventdata.eventName ?? 'Нет названия',
                        const Size(351, 60)),
                    SizedBox(height: 250),
                    _buildRoundedTextFormField(
                        initialValue:
                            successState.eventdata.eventType ?? 'Нет типа'),
                    SizedBox(height: 16),
                    _buildRoundedTextFormField(
                      initialValue: successState.eventdata.eventDate != null
                          // ? dateFormat.format(successState.eventdata.eventDate!)
                          ? successState.eventdata.eventDate!
                          : 'Нет даты',
                    ),
                    SizedBox(height: 16),
                    _buildRoundedTextFormField(
                      initialValue: successState.eventdata.eventTime != null
                          // ? timeFormat.format(DateTime(
                          //     2000,
                          //     1,
                          //     1,
                          //     successState.eventdata.eventTime!.hour,
                          //     successState.eventdata.eventTime!.minute))
                          ? successState.eventdata.eventTime!
                          : 'Нет времени',
                    ),
                    SizedBox(height: 16),
                    _buildRoundedTextFormField(
                        initialValue: successState.eventdata.eventAddress ??
                            'Нет адреса'),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildRoundedButton(
                            context,
                            'Меню',
                            () => Navigator.pushNamed(
                                  context,
                                  '/informationFood',
                                  arguments: {'documentId': documentId},
                                ),
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
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
