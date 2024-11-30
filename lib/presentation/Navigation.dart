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
        return MaterialPageRoute(builder: (context) => WishlistPage());
      case '/food':
        return MaterialPageRoute(builder: (context) => FoodPage());
      case '/guest':
        return MaterialPageRoute(builder: (context) => GuestsPage());
      case '/profile':
        return MaterialPageRoute(builder: (context) => ProfilePage());
      case '/my_event':
        return MaterialPageRoute(builder: (context) => MyEventsPage());
      case '/archive_of_events':
        return MaterialPageRoute(builder: (context) => ArchiveOfEventsPage());
      default:
        return MaterialPageRoute(
            builder: (context) => const Scaffold(
                  body: Center(child: Text('404')),
                ));
    }
  }
}
