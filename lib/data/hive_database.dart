import 'package:hive/hive.dart';
import 'package:notes_app/model/note.dart';

class HiveDatabase {
  //reference our hive box
  final _myBox = Hive.box('note_database');

  //load notes
  List<Note> loadNotes() {
    List<Note> saveNotesFormatted = [];

    //if there exists note, return that, otherwise return empty list
    if (_myBox.get("ALL_NOTES") != null) {
      List<dynamic> saveNotes = _myBox.get("ALL_NOTES");
      for (int i = 0; i < saveNotes.length; i++) {
        //create individual note
        Note individualNote = Note(saveNotes[i][0], saveNotes[i][i]);
        //add to list
        saveNotesFormatted.add(individualNote);
      }
    } else {
      saveNotesFormatted.add(Note(0, 'First Note'));
    }

    return saveNotesFormatted;
  }

  //save notes
  void saveNotes(List<Note> allNotes) {
    List<List<dynamic>> allNotesFormatted = [];

    //each note has id and text
    for (var note in allNotes) {
      int id = note.id;
      String text = note.text;
      allNotesFormatted.add([id, text]);
    }

    //then store into hive
    _myBox.put("ALL_NOTES", allNotesFormatted);
  }
}
