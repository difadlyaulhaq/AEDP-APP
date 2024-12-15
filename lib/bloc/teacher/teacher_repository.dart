import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
class TeacherRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload file ke Firebase Storage
  Future<String> uploadFile(String filePath, String fileName) async {
    final fileRef = _storage.ref().child('materials/$fileName');
    final uploadTask = await fileRef.putFile(File(filePath));
    return await uploadTask.ref.getDownloadURL();
  }

  // Tambah data baru ke Firestore
  Future<void> addMaterial(String title, String description, String fileUrl) async {
    await _firestore.collection('materials').add({
      'title': title,
      'description': description,
      'fileUrl': fileUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Ambil data dari Firestore
  Stream<List<Map<String, dynamic>>> getMaterials() {
    return _firestore.collection('materials').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // Hapus data
  Future<void> deleteMaterial(String id) async {
    await _firestore.collection('materials').doc(id).delete();
  }
}
