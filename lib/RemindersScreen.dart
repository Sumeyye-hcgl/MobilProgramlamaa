import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'reminders_provider.dart';

class RemindersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final reminderProvider = Provider.of<ReminderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hatırlatıcılar'),
      ),
      body: ListView.builder(
        itemCount: reminderProvider.reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminderProvider.reminders[index];
          return ListTile(
            title: Text(reminder.title),
            subtitle: Text(reminder.dateTime.toString()),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                reminderProvider.deleteReminder(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          _showAddReminderDialog(context, reminderProvider);
        },
      ),
    );
  }

  void _showAddReminderDialog(
      BuildContext context, ReminderProvider reminderProvider) {
    final TextEditingController titleController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Yeni Hatırlatıcı'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration:
                    InputDecoration(hintText: 'Hatırlatıcı başlığı girin'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null && picked != selectedDate) {
                    selectedDate = picked;
                  }
                },
                child: Text('Tarih Seç'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  reminderProvider.addReminder(
                      titleController.text, selectedDate);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Ekle'),
            ),
          ],
        );
      },
    );
  }
}
