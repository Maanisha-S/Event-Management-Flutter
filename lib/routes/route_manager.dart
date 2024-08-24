import 'package:event_management/routes/routes.dart';
import 'package:event_management/screens/add_event/add_event_page.dart';
import 'package:event_management/screens/event_details/event_details_page.dart';
import 'package:event_management/screens/login/login_page.dart';
import 'package:event_management/screens/search_events/search_events.dart';
import 'package:event_management/screens/sign_up/sign_up.dart';
import 'package:flutter/material.dart';


class InstantPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  InstantPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        );
}

class RouteManager {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case EventBookingAppRoutes.loginRoute:
        return InstantPageRoute(page: const LoginPage());
      case EventBookingAppRoutes.signupRoute:
        return InstantPageRoute(page: const SignUpPage());
      case EventBookingAppRoutes.searchEventsRoute:
        return InstantPageRoute(page:  const EventsListScreen());
      case EventBookingAppRoutes.eventDetailsRoute:
        final args = settings.arguments as Map<String, dynamic>;
        final eventId = args['id'] as String;
        return InstantPageRoute(page:   EventDetailScreen(eventId: eventId,));
      case EventBookingAppRoutes.addEventRoute:
        return InstantPageRoute(page:  const AddEventScreen());
        default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Unknown Route')),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
