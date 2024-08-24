import 'package:event_management/controller/auth_services.dart';
import 'package:event_management/routes/routes.dart';
import 'package:event_management/widgets/appbar_design.dart';
import 'package:event_management/widgets/event_card_design.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsListScreen extends StatefulWidget {
  const EventsListScreen({super.key});

  @override
  _EventsListScreenState createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        icon: const Icon(
          Icons.add_circle,
          color: Color(0xFF1F1A38),
          size: 60,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(EventBookingAppRoutes.addEventRoute);
        },
      ),
      appBar: AppBarDesign(
        title: 'Events',
        size: 25,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              await AuthService.logout();
              Navigator.of(context).pushReplacementNamed(EventBookingAppRoutes.loginRoute);
            },
          ),
        ],
        leadingIcon: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search by title',
                labelStyle: const TextStyle(color: Color(0xFF1F1A38)),
                hintStyle: const TextStyle(color: Color(0xFF1F1A38)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1F1A38)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF1F1A38)),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      searchQuery = "";
                    });
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('events')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> eventSnapshot) {
                if (eventSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final eventDocs = eventSnapshot.data!.docs;
                final filteredDocs = eventDocs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final title = data['title'] ?? '';
                  return title.toLowerCase().contains(searchQuery);
                }).toList();
                return ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (ctx, index) {
                    final event = filteredDocs[index];
                    final data = event.data() as Map<String, dynamic>;
                    final description = data['description'] ?? '';
                    final eventDate = data.containsKey('date') && data['date'] is Timestamp
                        ? data['date'].toDate()
                        : null;

                    return EventCard(
                      title: data['title'] ?? '',
                      description: description,
                      eventDate: eventDate,
                      eventId: event.id,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
