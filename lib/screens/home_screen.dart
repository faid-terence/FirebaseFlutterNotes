import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_auth/components/custom_text_field.dart';
import 'package:flutter_simple_auth/components/note_list.dart';
import 'package:flutter_simple_auth/services/firestore_notes_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // note controller
  final TextEditingController noteController = TextEditingController();

  // firebase instance
  final currentUser = FirebaseAuth.instance.currentUser;
  final FirestoreNotesServices firestoreNotesServices =
      FirestoreNotesServices();

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  // open a dialog to add note
  void addNoteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Add Note",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Customtextfield(
            hintText: "Enter Note",
            obscureText: false,
            textEditingController: noteController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                firestoreNotesServices.createNote(noteController.text);
                noteController.clear();
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // Dialog for updating notes
  void updateNoteDialog(String noteId, String currentNote) {
    noteController.text = currentNote;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Update Note",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Customtextfield(
            hintText: "Enter Note",
            obscureText: false,
            textEditingController: noteController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                firestoreNotesServices.updateNote(noteController.text, noteId);
                noteController.clear();
                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Notes App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              logout();
            },
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNoteDialog();
        },
        backgroundColor: Colors.black87,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder(
          stream: firestoreNotesServices.getNotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.black87),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            // Check if we have data
            if (snapshot.hasData) {
              List notes = snapshot.data!.docs;

              return NotesList(
                notes: notes,
                firestoreNotesServices: firestoreNotesServices,
                onUpdateNote: updateNoteDialog,
              );
            } else {
              return const Center(child: Text("No notes available"));
            }
          },
        ),
      ),
    );
  }
}
