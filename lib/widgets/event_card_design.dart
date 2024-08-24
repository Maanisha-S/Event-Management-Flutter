import 'package:event_management/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String description;
  final DateTime? eventDate;
  final String eventId;

  const EventCard({super.key,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Color(0xFF7e76a8),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:  Color(0XFF180f47),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.event, color: Color(0xFF1F1A38)),
                    const SizedBox(width: 10),
                    if (eventDate != null) // Only show the date if it exists
                      Text(
                        'Date: ${DateFormat('yyyy-MM-dd').format(eventDate!)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color:Colors.deepPurple,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: description.length > 15
                        ? description.substring(0, 15)
                        : description,
                    style: const TextStyle(
                      fontSize: 14,
                      color:Colors.black,
                    ),
                    children: [
                      if (description.length > 15)
                        const TextSpan(
                          text: '... See more',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0XFF180f47),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      EventBookingAppRoutes.eventDetailsRoute,
                      arguments: {
                        'id': eventId,
                      },
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF7e76a8)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
