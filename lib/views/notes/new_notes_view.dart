import 'package:flutter/material.dart';
import 'package:myapp/services/auth/auth_service.dart';
import 'package:myapp/services/crud/notes_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    if (_note == null) return;
    final text = _textController.text;
    await _notesService.updateNote(note: _note!, text: text);
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<void> createNewNote() async {
    if (_note != null) return;

    final currentUser = AuthService.firebase().currentUser;
    if (currentUser == null) {
      return;
    }

    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    
    final newNote = await _notesService.createNote(owner: owner);

    if (newNote != null) {
      setState(() {
        _note = newNote;
      });
      _textController.text = newNote.text;
    }
  }

  void _deleteNoteIfTextIsEmpty() {
    if (_textController.text.isEmpty && _note != null) {
      _notesService.deleteNote(id: _note!.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    if (_note != null && _textController.text.isNotEmpty) {
      await _notesService.updateNote(note: _note!, text: _textController.text);
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Note')),
      body: FutureBuilder(
        future: createNewNote(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            _setupTextControllerListener();
            return TextField(
              controller: _textController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Start typing your note...',
              ),
            );
          }
        },
      ),
    );
  }
}
