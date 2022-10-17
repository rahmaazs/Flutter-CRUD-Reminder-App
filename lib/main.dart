import 'package:flutter/material.dart';
import 'database/db_reminder.dart';
import 'form_reminder.dart';
import 'list_reminder.dart';
import 'model/reminder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: ListReminderPage(),
    );
  }
}
