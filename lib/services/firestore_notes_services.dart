import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreNotesServices {
  // get collection for notes

  final CollectionReference notesCollection = FirebaseFirestore.instance
      .collection('notes');

  final currentUser = FirebaseAuth.instance.currentUser;

  // CREATE with logged in user
  Future<void> createNote(String note) {
    return notesCollection.add({
      'note': note,
      'ownerId': currentUser?.uid,
      'createdAt': Timestamp.now(),
    });
  }

  // retrieve notes for logged in user
  Stream<QuerySnapshot> getNotes() {
    return notesCollection
        .where('ownerId', isEqualTo: currentUser?.uid)
        .snapshots();
  }

  // Update note

  Future<void> updateNote(String note, String id) {
    return notesCollection.doc(id).update({'note': note});
  }

  // Delete note

  Future<void> deleteNotes(String id) {
    return notesCollection.doc(id).delete();
  }
}
