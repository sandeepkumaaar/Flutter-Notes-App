import 'package:flutter/material.dart';
import 'package:notes_app/data/hive_database.dart';
import 'package:notes_app/model/note.dart';

class NoteData extends ChangeNotifier {
  //hive database
  final db = HiveDatabase();

  //overall list of notes
  List<Note> allNotes = [];

  //initialize the list
  void initiazeNotes() {
    allNotes = db.loadNotes();
  }

  // get notes
  List<Note> getAllNotes() {
    return allNotes;
  }

  // add a new note
  void addNewNote(Note note) {
    allNotes.add(note);
    notifyListeners();
  }

  //updates notes
  void updateNote(Note note, String txt) {
    // go through list of all notes
    for (int i = 0; i < allNotes.length; i++) {
      if (allNotes[i].id == note.id) {
        allNotes[i].text = txt;
      }
    }
    notifyListeners();
  }

  //delete notes
  void deleteNote(Note note) {
    allNotes.remove(note);
    notifyListeners();
  }
}
