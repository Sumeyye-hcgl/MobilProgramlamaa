import 'package:flutter/material.dart';

class Reminder {
  final String title;
  final DateTime dateTime;

  Reminder({required this.title, required this.dateTime});
}

class ReminderProvider extends ChangeNotifier {
  final List<Reminder> _reminders = [];

  List<Reminder> get reminders => _reminders;

  void addReminder(String title, DateTime dateTime) {
    _reminders.add(Reminder(title: title, dateTime: dateTime));
    notifyListeners();
  }

  void deleteReminder(int index) {
    _reminders.removeAt(index);
    notifyListeners();
  }
}
