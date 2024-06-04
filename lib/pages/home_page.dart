import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/model/note.dart';
import 'package:notes_app/model/note_data.dart';
import 'package:notes_app/pages/editing_note_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<NoteData>(context, listen: false).initiazeNotes();
  }

  //create a note
  void createNewNote() {
    //create a new id
    int id = Provider.of<NoteData>(context, listen: false).getAllNotes().length;

    Note newNote = Note(id, '');

    //go to edit  the note
    gotoNotePage(newNote, true);
  }

  //go to note editing page
  void gotoNotePage(Note note, bool isNewNote) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditingNotePage(
            note: note,
            isNewNote: isNewNote,
          ),
        ));
  }

  //delete note
  void deleteNote(Note note) {
    Provider.of<NoteData>(context, listen: false).deleteNote(note);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteData>(
        builder: (context, value, child) => Scaffold(
              backgroundColor: CupertinoColors.systemGroupedBackground,
              floatingActionButton: FloatingActionButton(
                onPressed: createNewNote,
                elevation: 0,
                backgroundColor: Colors.grey[300],
                child: const Icon(
                  Icons.add,
                  color: Colors.grey,
                ),
              ),
              // appBar: AppBar(),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 25.0, top: 75.0),
                    child: Text(
                      'Notes',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),

                  //list of notes
                  value.getAllNotes().isEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(top: 50.0),
                          child: Center(
                            child: Text(
                              'Nothing here...',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : CupertinoListSection.insetGrouped(
                          children: List.generate(
                              value.getAllNotes().length,
                              (index) => CupertinoListTile(
                                    title:
                                        Text(value.getAllNotes()[index].text),
                                    onTap: () => gotoNotePage(
                                        value.getAllNotes()[index], false),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => deleteNote(
                                          value.getAllNotes()[index]),
                                    ),
                                  )),
                        ),
                ],
              ),
            ));
  }
}
