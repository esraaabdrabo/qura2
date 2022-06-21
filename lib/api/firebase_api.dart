import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  //return task to know its download url////
  static UploadTask? uploadFile(String destination, File file) {
    try {
      Reference ref = FirebaseStorage.instance.ref(destination);
      print('in upload');
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      print(
          'FirebaseException from [[[[uploadFile]]]] firebase_api.dart e:message => ${e.message} e:toString=>     ${e.toString()}');
      return null;
    }
  }
}
