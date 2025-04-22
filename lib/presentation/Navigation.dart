import 'package:flutter/material.dart';
import 'package:event_horizon/presentation/pages/SplashScreen_page/SplashScreen_page.dart';
import 'package:event_horizon/presentation/pages/menu_page/menu_page.dart';
import 'package:event_horizon/presentation/pages/creating_event_page/creating_event_page.dart';
import 'package:event_horizon/presentation/pages/wishlist_page/wishlist_page.dart';
import 'package:event_horizon/presentation/pages/food_page/food_page.dart';
import 'package:event_horizon/presentation/pages/guests_page/guests_page.dart';
import 'package:event_horizon/presentation/pages/profile_page/profile_page.dart';
import 'package:event_horizon/presentation/pages/my_events/my events.dart';
import 'package:event_horizon/presentation/pages/archive_of_events/archive_of_events.dart';
import 'package:event_horizon/presentation/pages/registration_page/registration_page.dart';
import 'package:event_horizon/presentation/pages/registration_page/registration_page1.dart';
import 'package:event_horizon/presentation/pages/information_about_the_event/information_about_the_event.dart';
import 'package:event_horizon/presentation/pages/food_page/information_food_page.dart';
import 'package:event_horizon/presentation/pages/wishlist_page/information_wishlist_page.dart';

class Navigation {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const Splashscreen());
      case '/menu':
        return MaterialPageRoute(builder: (context) => const Menu());
      case '/create_event':
        return MaterialPageRoute(
            builder: (context) => const CreatingAnEventPage());
      case '/wishlist':
        final args = settings.arguments as Map<String, dynamic>?;
        final documentId =
            args?['documentId'] as String?; //  Получаем documentId

        return MaterialPageRoute(
          builder: (context) => WishlistListScreen(
            documentId: documentId ?? '', //  Используем documentId
          ),
        );
      case '/food':
        final args = settings.arguments as Map<String, dynamic>?;
        final documentId =
            args?['documentId'] as String?; //  Получаем documentId

        return MaterialPageRoute(
          builder: (context) => foodListScreen(
            documentId: documentId ?? '', //  Используем documentId
          ),
        );
      case '/guest':
        final args = settings.arguments as Map<String, dynamic>?;
        final documentId =
            args?['documentId'] as String?; //  Получаем documentId

        return MaterialPageRoute(
          builder: (context) => guestListScreen(
            documentId: documentId ?? '', //  Используем documentId
          ),
        );
      case '/profile':
        return MaterialPageRoute(builder: (context) => ProfilePage());
      case '/my_event':
        return MaterialPageRoute(builder: (context) => MyEventsPage());
      case '/archive_of_events':
        return MaterialPageRoute(builder: (context) => ArchiveOfEventsPage());
      case '/registration':
        return MaterialPageRoute(builder: (context) => RegistrationPage());
      case '/registration1':
        return MaterialPageRoute(builder: (context) => RegistrationPage1());
      case '/eventInfo': // Обрабатываем маршрут '/eventInfo'
        // Получаем аргументы из settings.arguments
        final args =
            settings.arguments as Map<String, dynamic>?; // Проверяем на null
        final documentId = args?['documentId']
            as String?; // Получаем documentId и обрабатываем null

        // Проверяем, что documentId не null
        if (documentId != null) {
          return MaterialPageRoute(
              builder: (context) => EventInfoScreen(documentId: documentId));
        } else {
          // Если documentId null, отображаем экран ошибки или возвращаемся назад
          return MaterialPageRoute(
              builder: (context) => const Scaffold(
                  body:
                      Center(child: Text('Ошибка: Document ID отсутствует'))));
        }
      case '/informationFood':
        final args = settings.arguments as Map<String, dynamic>?;
        final documentId = args?['documentId'] as String?;
        return MaterialPageRoute(
          builder: (context) =>
              InformationFoodPage(documentId: documentId ?? ''),
        );
      case '/informationwishlist':
        final args = settings.arguments as Map<String, dynamic>?;
        final documentId = args?['documentId'] as String?;
        return MaterialPageRoute(
          builder: (context) =>
              InformationWishlistPage(documentId: documentId ?? ''),
        );
      default:
        return MaterialPageRoute(
            builder: (context) => const Scaffold(
                  body: Center(child: Text('404')),
                ));
    }
  }
}
