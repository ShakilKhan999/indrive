import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class MethodHelper {
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }

  Future<String?> uploadImage(
      {required File file, required String imageLocationName}) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("$imageLocationName/$fileName");
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      log('Error when uploading image : $e');
      return null;
    }
  }

  Future<bool> updateDocFields(
      {required String docId,
      required Map<String, dynamic> fieldsToUpdate,
      required String collection}) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection(collection);
      await users.doc(docId).update(fieldsToUpdate);
      log('User fields updated successfully');
      return true;
    } catch (e) {
      log('Error updating user fields: $e');
      return false;
    }
  }
}
