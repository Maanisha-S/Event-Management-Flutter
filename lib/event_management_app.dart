import 'package:event_management/routes/route_manager.dart';
import 'package:event_management/routes/routes.dart';
import 'package:flutter/material.dart';

class EventBookingApp extends StatelessWidget {
  const EventBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: EventBookingAppRoutes.loginRoute,
      onGenerateRoute: RouteManager.generateRoute,
    );
  }
}