import 'package:event_management/controller/notification_services.dart';
import 'package:event_management/widgets/appbar_design.dart';
import 'package:event_management/widgets/material_button_design.dart';
import 'package:event_management/widgets/text_form_design.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  DateTime startDateTime = DateTime.now();
  TimeOfDay _endTime = TimeOfDay.now();
  int _memberCount = 0;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _pickStartTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );

    if (pickedTime != null) {
      setState(() {
        _startTime = pickedTime;
      });
    }
  }

  void _pickEndTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );

    if (pickedTime != null) {
      setState(() {
        _endTime = pickedTime;
      });
    }
  }
  void _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not authenticated')),
        );
        return;
      }

      DateTime startDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _startTime.hour,
        _startTime.minute,
      );

      DateTime endDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _endTime.hour,
        _endTime.minute,
      );

      debugPrint('Time : $startDateTime');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('events')
          .add({
        'title': _title,
        'description': _description,
        'date': _selectedDate,
        'start_time': startDateTime,
        'end_time': endDateTime,
        'member_count': _memberCount,
        'timestamp': Timestamp.now(),
      });

      Navigator.of(context).pop();

      NotificationService notificationService = NotificationService();
      await notificationService.initNotification();

      await notificationService.showNotification(
        title: 'Event Saved',
        body: 'Your event has been successfully saved.',
      );

      await notificationService.scheduleNotification(
        title: _title,
        body: _description,
        scheduledNotificationDateTime: startDateTime,
      );
    }
  }

  // void _saveEvent() async {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();
  //
  //     startDateTime = DateTime(
  //       _selectedDate.year,
  //       _selectedDate.month,
  //       _selectedDate.day,
  //       _startTime.hour,
  //       _startTime.minute,
  //     );
  //
  //     DateTime endDateTime = DateTime(
  //       _selectedDate.year,
  //       _selectedDate.month,
  //       _selectedDate.day,
  //       _endTime.hour,
  //       _endTime.minute,
  //     );
  //
  //     debugPrint('Time : $startDateTime');
  //
  //     await FirebaseFirestore.instance.collection('events').add({
  //       'title': _title,
  //       'description': _description,
  //       'date': _selectedDate,
  //       'start_time': startDateTime,
  //       'end_time': endDateTime,
  //       'member_count': _memberCount,
  //       'timestamp': Timestamp.now(),
  //     });
  //
  //     Navigator.of(context).pop();
  //
  //
  //     NotificationService notificationService = NotificationService();
  //     await notificationService.initNotification();
  //
  //     await notificationService.showNotification(
  //       title: 'Event Saved',
  //       body: 'Your event has been successfully saved.',
  //     );
  //
  //     await notificationService.scheduleNotification(
  //       title: _title,
  //       body: _description,
  //       scheduledNotificationDateTime: startDateTime,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const AppBarDesign(title : "Add Event", leadingIcon: true,),
      body: FadeTransition(
        opacity: _animation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30,),
                  TextFormFieldDesign(labelText: 'Title',
                    validatorText: 'Please enter a title',
                    keyboardType: TextInputType.text,
                    onSaved: (value) {
                      _title = value!;
                    },
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      _pickDate();
                    },
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF1F1A38),),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.calendar_today,
                                  color: Color(0xFF1F1A38),),
                              onPressed: _pickDate),
                          Text(
                              'Select Date: ${DateFormat.yMd().format(_selectedDate)}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      _pickStartTime();
                    },
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF1F1A38),),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.access_time,
                                  color:Color(0xFF1F1A38),),
                              onPressed: _pickStartTime),
                          Text(
                              'Start Time: ${_startTime.format(context)}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      _pickEndTime();
                    },
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(color:const Color(0xFF1F1A38),),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.access_time,
                                  color: Color(0xFF1F1A38),),
                              onPressed: _pickEndTime),
                          Text(
                              'End Time: ${_endTime.format(context)}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormFieldDesign(labelText: 'Number of Members',
                    validatorText: 'Please enter number of members',
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _memberCount = int.parse(value!);
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormFieldDesign(labelText: 'Description',maxLines: 2,
                    keyboardType: TextInputType.text,
                    validatorText: 'Please enter a description',
                    onSaved: (value) {
                      _description = value!;
                    },
                  ),
                  const SizedBox(height: 50),
                  MaterialButtonDesign(height: 30,width: 100,text: 'Save Event',onTap: (){
                    _saveEvent();
                    },),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



