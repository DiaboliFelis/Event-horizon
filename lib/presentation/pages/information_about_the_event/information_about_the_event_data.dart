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
  final String? eventDescription;
  final String? eventType;
  final String? eventDate;
  final String? eventTime;
  final String? eventAddress;

  EventData({
    required this.eventName,
    required this.eventDescription,
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
        eventDescription: null,
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
      final querySnapshot =
          await FirebaseFirestore.instance.collection('events').get();

// Filter documents after getting the snapshot
      List<DocumentSnapshot> filteredDocs = [];
      for (var document in querySnapshot.docs) {
        final data = document.data() as Map<String, dynamic>;
        final userId = data['userId'] as String?;
        final attendingUsers = data['attendingUsers'] as List<dynamic>?;

        final isCreator = userId == user.uid;
        final isAttending = attendingUsers?.contains(user.uid) == true;

        if (isCreator || isAttending) {
          filteredDocs.add(document);
        }
      }

// Now you iterate on filteredDocs instead of querySnapshot.docs.
      DocumentSnapshot? doc;
      for (var document in filteredDocs) {
        if (document.id == documentId) {
          doc = document;
          break; // Found the desired document, exit the loop
        }
      }

      //Проверяем, нашли ли мы документ
      if (doc != null && doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final eventdata = EventData(
            eventName: data['eventName'],
            eventDescription: data['eventDescription'],
            eventType: data['eventType'],
            eventDate: data['eventDate'],
            eventTime: data['eventTime'],
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
