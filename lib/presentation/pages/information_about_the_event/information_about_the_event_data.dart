import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

abstract class InformationAboutTheEventState {
  const InformationAboutTheEventState();
}

class InfAboutTheEventLoadInProgress extends InformationAboutTheEventState {
  const InfAboutTheEventLoadInProgress();
}

class InfAboutTheEventLoadSuccess extends InformationAboutTheEventState {
  final EventData eventdata;

  const InfAboutTheEventLoadSuccess(this.eventdata);
}

class EventData {
  final String? eventName;
  final String? eventType;
  final String? eventDate;
  final String? eventTime;
  final String? eventAddress;

  EventData({
    required this.eventName,
    required this.eventType,
    required this.eventDate,
    required this.eventTime,
    required this.eventAddress,
  });
}

class EventCubit extends Cubit<InformationAboutTheEventState> {
  EventCubit() : super(const InfAboutTheEventLoadInProgress());

  Future<void> onPageOpened(String documentId) async {
    final emptyData = EventData(
        eventName: null,
        eventType: null,
        eventDate: null,
        eventTime: null,
        eventAddress: null);
    try {
      final user =
          FirebaseAuth.instance.currentUser; //  Получаем текущего пользователя
      if (user == null) {
        // Если пользователь не авторизован, показываем пустые данные
        emit(InfAboutTheEventLoadSuccess(emptyData));
        return; //  Прерываем выполнение функции
      }
      // Получаем все мероприятия, созданные текущим пользователем
      final querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('userId', isEqualTo: user.uid)
          .get();

      // Ищем нужный документ по documentId среди результатов запроса
      DocumentSnapshot? doc;
      for (var document in querySnapshot.docs) {
        if (document.id == documentId) {
          doc = document;
          break; // Нашли нужный документ, выходим из цикла
        }
      }

      //Проверяем, нашли ли мы документ
      if (doc != null && doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final eventdata = EventData(
            eventName: data['eventName'],
            eventType: data['eventType'],
            eventDate: data['eventTime'],
            eventTime: data['eventDate'],
            eventAddress: data['eventAddress']);

//Передаём состояние и данные на страницу
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
}
