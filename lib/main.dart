import 'package:event_management/controller/notification_services.dart';
import 'package:event_management/event_management_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tzData;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyA0Je3MllNX-KAfakkIHPoIrbXo7Zd4BUQ",
        appId: "1:126898940790:android:bebf059f5d8ac53e95e857",
        messagingSenderId: '126898940790',
        projectId: "eventmanagement-81b5c",
      ));
  NotificationService().initNotification();
  tzData.initializeTimeZones();
  runApp(const EventBookingApp());
}

