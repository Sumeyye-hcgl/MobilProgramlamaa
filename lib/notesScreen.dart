import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notes_provider.dart';

class NotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notlar'),
      ),
      body: notesProvider.notes.isEmpty
          ? Center(
              child: Text(
                'Hiç not bulunamadı.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: notesProvider.notes.length,
              itemBuilder: (context, index) {
                final note = notesProvider.notes[index];
                return ListTile(
                  title: Text(note.title),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      notesProvider.deleteNote(index);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          _showAddNoteDialog(context, notesProvider);
        },
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context, NotesProvider notesProvider) {
    final TextEditingController noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Yeni Not'),
          content: TextField(
            controller: noteController,
            decoration: InputDecoration(hintText: 'Not girin'),
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
                if (noteController.text.isNotEmpty) {
                  notesProvider.addNote(noteController.text);
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
