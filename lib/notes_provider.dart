import 'package:flutter/material.dart';

class Notes {
  final String title;
  bool isCompleted;

  Notes({required this.title, this.isCompleted = false});
}

class NotesProvider extends ChangeNotifier {
  final List<Notes> _notes = [];

  List<Notes> get notes => _notes;

  void addNote(String title) {
    _notes.add(Notes(title: title));
    notifyListeners();
  }

  void deleteNote(int index) {
    if (index >= 0 && index < _notes.length) {
      _notes.removeAt(index);
      notifyListeners();
    }
  }
}
