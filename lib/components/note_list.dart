import 'package:flutter/material.dart';
import 'package:flutter_simple_auth/services/firestore_notes_services.dart';

class NotesList extends StatelessWidget {
  final List notes;
  final FirestoreNotesServices firestoreNotesServices;
  final Function(String noteId, String currentNote) onUpdateNote;

  const NotesList({
    super.key,
    required this.notes,
    required this.firestoreNotesServices,
    required this.onUpdateNote,
  });

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_add, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "No notes found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Tap the + button to add your first note!",
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return NoteCard(
          note: notes[index]['note'],
          noteId: notes[index].id,
          firestoreNotesServices: firestoreNotesServices,
          onUpdateNote: onUpdateNote,
        );
      },
    );
  }
}

class NoteCard extends StatelessWidget {
  final String note;
  final String noteId;
  final FirestoreNotesServices firestoreNotesServices;
  final Function(String noteId, String currentNote) onUpdateNote;

  const NoteCard({
    super.key,
    required this.note,
    required this.noteId,
    required this.firestoreNotesServices,
    required this.onUpdateNote,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          title: Text(note, style: const TextStyle(fontSize: 16)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onUpdateNote(noteId, note),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _showDeleteConfirmation(context);
                },
              ),
            ],
          ),
          onTap: () => onUpdateNote(noteId, note),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("Delete Note"),
            content: const Text("Are you sure you want to delete this note?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  firestoreNotesServices.deleteNotes(noteId);
                  Navigator.pop(context);
                },
                child: const Text("Delete"),
              ),
            ],
          ),
    );
  }
}
