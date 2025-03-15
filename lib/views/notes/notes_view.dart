import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/constants/routes.dart';
import 'package:myapp/enums/menu_action.dart';
import 'package:myapp/services/auth/auth_service.dart';
import 'package:myapp/services/auth/bloc/auth_bloc.dart';
import 'package:myapp/services/auth/bloc/auth_event.dart';
import 'package:myapp/services/cloud/cloud_note.dart';
import 'package:myapp/services/cloud/firebase_cloud_storage.dart';
import 'package:myapp/utilities/dialogs/logout_dialog.dart';
import 'package:myapp/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E), // Darker app bar
        title: const Text(
          'Your Notes',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white, // White text for contrast
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createUpdateNoteRoute);
            },
            icon: const Icon(Icons.add, size: 28, color: Colors.white),
          ),
          PopupMenuButton<MenuAction>(
            color: Colors.black87, // Dark popup menu
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('Log Out', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                if (allNotes.isEmpty) {
                  return const Center(
                    child: Text(
                      'No notes yet. Click + to add one!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white70),
                    ),
                  );
                }
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: NotesListView(
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(documentId: note.documentId);
                    },
                    onTap: (note) {
                      Navigator.of(context).pushNamed(createUpdateNoteRoute, arguments: note);
                    },
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }
            default:
              return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
        },
      ),
    );
  }
}
