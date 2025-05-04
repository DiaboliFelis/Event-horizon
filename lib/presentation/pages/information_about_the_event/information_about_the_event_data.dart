import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// Состояния загрузки информации о мероприятии
abstract class InformationAboutTheEventState {
  const InformationAboutTheEventState();
}

// Состояние загрузки в процессе
class InfAboutTheEventLoadInProgress extends InformationAboutTheEventState {
  const InfAboutTheEventLoadInProgress();
}

// Состояние успешной загрузки
class InfAboutTheEventLoadSuccess extends InformationAboutTheEventState {
  final EventData eventdata;
  final String? notificationTime;

  const InfAboutTheEventLoadSuccess(this.eventdata, {this.notificationTime});
}

// Модель данных о мероприятии
class EventData {
  final String? eventName;
  final String? eventDescription;
  final String? eventType;
  final String? eventDate;
  final String? eventTime;
  final String? eventAddress;
  final bool isEventOwner; // Флаг организатора
  final bool isGuest; // Флаг гостя

  EventData({
    required this.eventName,
    required this.eventDescription,
    required this.eventType,
    required this.eventDate,
    required this.eventTime,
    required this.eventAddress,
    required this.isEventOwner,
    required this.isGuest,
  });
}

// Cubit для управления состоянием информации о мероприятии
class EventCubit extends Cubit<InformationAboutTheEventState> {
  EventCubit() : super(const InfAboutTheEventLoadInProgress());

  // Метод загрузки данных при открытии страницы
  Future<void> onPageOpened(String documentId) async {
    // Создаем пустые данные по умолчанию
    final emptyData = EventData(
      eventName: null,
      eventDescription: null,
      eventType: null,
      eventDate: null,
      eventTime: null,
      eventAddress: null,
      isEventOwner: false,
      isGuest: false,
    );

    try {
      // Получаем текущего пользователя
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Если пользователь не авторизован, показываем пустые данные
        emit(InfAboutTheEventLoadSuccess(emptyData));
        return; // Прерываем выполнение функции
      }

      // Получаем документ мероприятия из Firestore
      final doc = await FirebaseFirestore.instance
          .collection('events')
          .doc(documentId)
          .get();

      // Проверяем, существует ли документ
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        // Определяем роль пользователя:
        // isCreator - true если пользователь создатель мероприятия
        // isAttending - true если пользователь в списке приглашенных
        final isCreator = data['userId'] == user.uid;
        final attendingUsers = data['attendingUsers'] as List? ?? [];
        final isAttending = attendingUsers.contains(user.uid);

        // Создаем объект с данными о мероприятии
        final eventdata = EventData(
          eventName: data['eventName'],
          eventDescription: data['eventDescription'],
          eventType: data['eventType'],
          eventDate: data['eventDate'],
          eventTime: data['eventTime'],
          eventAddress: data['eventAddress'],
          isEventOwner: isCreator,
          isGuest: isAttending &&
              !isCreator, // Гость - если приглашен, но не создатель
        );

        // Передаем состояние и данные на страницу
        emit(InfAboutTheEventLoadSuccess(eventdata));
      } else {
        print('Документ не найден');
        emit(InfAboutTheEventLoadSuccess(emptyData));
      }
    } catch (e) {
      print('Ошибка при загрузке данных: $e');
      emit(InfAboutTheEventLoadSuccess(emptyData));
    }
  }

  // Метод сохранения общих настроек уведомлений
  Future<void> saveNotificationPreference(String notificationTime) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      await FirebaseFirestore.instance
          .collection('user_settings')
          .doc(userId) //  Используем userId как documentId
          .set({
        'notificationTime': notificationTime,
      });
      print('Общие настройки уведомления сохранены');
    } catch (e) {
      print('Ошибка при сохранении настроек уведомления: $e');
    }
  }

  // Метод для получения общих настроек уведомлений
  Future<String?> getNotificationPreference() async {
    //  Удален параметр eventId
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('user_settings')
          .doc(userId) //  Используем userId как documentId
          .get();
      if (doc.exists) {
        return doc.data()?['notificationTime'] as String?;
      }
      return null; //  Если настроек нет
    } catch (e) {
      print('Ошибка при получении настроек уведомления: $e');
      return null; //  Обработка ошибок
    }
  }
}
