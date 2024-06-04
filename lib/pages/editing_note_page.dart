import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes_app/model/note.dart';
import 'package:notes_app/model/note_data.dart';
import 'package:provider/provider.dart';

class EditingNotePage extends StatefulWidget {
  Note note;
  bool isNewNote;

  EditingNotePage({super.key, required this.note, required this.isNewNote});

  @override
  State<EditingNotePage> createState() => _EditingNotePageState();
}

class _EditingNotePageState extends State<EditingNotePage> {
  QuillController _controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    loadExistingNote();
  }

  //load the existing note
  void loadExistingNote() {
    final doc = Document()..insert(0, widget.note.text);

    setState(() {
      _controller = QuillController(
          document: doc, selection: const TextSelection.collapsed(offset: 0));
    });
  }

  //add a new note
  void addNewNote() {
    //get new id
    int id = Provider.of<NoteData>(context, listen: false).getAllNotes().length;
    //get the text from the edittext
    String text = _controller.document.toPlainText();
    //add the new note
    Provider.of<NoteData>(context, listen: false).addNewNote(
      Note(id, text),
    );
  }

  //update existing note
  void updateNote() {
    //get the text from the edittext
    String text = _controller.document.toPlainText();
    //update note
    Provider.of<NoteData>(context, listen: false).updateNote(widget.note, text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            //it's a new note
            if (widget.isNewNote && !_controller.document.isEmpty()) {
              addNewNote();
            }

            //it's a existing note
            else {
              updateNote();
            }

            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          //toolbar
          QuillProvider(
            configurations: QuillConfigurations(
              controller: _controller,
              sharedConfigurations:
                  const QuillSharedConfigurations(locale: Locale('en')),
            ),
            child: const Column(
              children: [
                QuillToolbar(),
              ],
            ),
          ),

          //editor
          QuillProvider(
            configurations: QuillConfigurations(controller: _controller),
            child: Expanded(
              child: Container(
                padding: const EdgeInsets.all(18),
                child: QuillEditor.basic(
                  configurations:
                      const QuillEditorConfigurations(readOnly: false),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
